class Mujs
  VERSION = "0.1.0"

  alias DefnArguments = Hash(Int32, Float64 | String)

  private macro must_be(ctype, msg)
    if LibMujs.js_type(@j, -1) != {{ctype}}
      raise ArgumentError.new({{msg}})
    end
  end

  private macro pop_as_string
    String.new(LibMujs.js_tostring(@j, -1))
  end

  private macro pop_as_number
    LibMujs.js_tonumber(@j, -1)
  end

  private macro pop_as_boolean
    (LibMujs.js_toboolean(@j, -1) > 0)
  end

  private macro cast_and_push(val)
    case {{val}}
    when Float64
      LibMujs.js_pushnumber(state, {{val}})
    when Int32
      LibMujs.js_pushnumber(state, {{val}})
    when String
      LibMujs.js_pushstring(state, {{val}})
    else
      raise "unknown how to cast value of type #{{{val}}.class}"
    end
  end

  private macro pop_and_cast
    _js_type = LibMujs.js_type(@j, -1)
    case _js_type
    when LibMujs::JsIsstring
      pop_as_string
    when LibMujs::JsIsnumber
      pop_as_number
    when LibMujs::JsIsboolean
      pop_as_boolean
    when LibMujs::JsIsnull
      nil
    else
      raise "unknow how to cast javascript type #{_js_type}"
    end
  end

  def initialize
    @j = LibMujs.js_newstate(nil, nil, 0)
  end

  def dostring(code : String)
    LibMujs.js_dostring(@j, code)
  end

  def call(fn_name : String, *args)
    LibMujs.js_getglobal(@j, fn_name)
    must_be(LibMujs::JsIsfunction, "`#{fn_name}` is not a function")
    LibMujs.js_pushnull(@j)
    if args.size > 0
      args.each do |arg|
        case arg
        when Int32
          LibMujs.js_pushnumber(@j, arg)
        when Float64
          LibMujs.js_pushnumber(@j, arg)
        when String
          LibMujs.js_pushstring(@j, arg)
        else
          raise ArgumentError.new("`#{fn_name}` not implemented casting for #{arg.class} of value `#{arg}`")
        end
      end
    end

    if LibMujs.js_pcall(@j, args.size) != 0
      raise "`#{fn_name}` #{pop_as_string}"
    end

    pop_and_cast
  end

  @@functions = Hash(String, Pointer(Void)).new

  def defn(fn_name, *types, &)
    capture = yield

    boxed_data = Box.box({capture, types})

    # avoid GC collector
    @@functions[fn_name] = boxed_data

    LibMujs.js_newcfunctionx(@j,
      ->(state) {
        data = LibMujs.js_currentfunctiondata(state)
        fn, fn_arg_types = Box(typeof({capture, types})).unbox(data)

        args = DefnArguments.new
        arg_idx = 0
        fn_arg_types.each do |arg_type|
          arg_idx += 1
          arg_key = arg_idx - 1
          case arg_type.to_s
          when "Int32"
            args[arg_key] = LibMujs.js_tonumber(state, arg_idx)
          when "Float64"
            args[arg_key] = LibMujs.js_tonumber(state, arg_idx)
          when "String"
            args[arg_key] = String.new(LibMujs.js_tostring(state, arg_idx))
          else
            raise "uknown how to handle argument type #{arg_type}"
          end
        end

        res = fn.call(args)
        cast_and_push(res)
      }, fn_name,
      types.size, boxed_data, nil)
    LibMujs.js_setglobal(@j, fn_name)
  end

  def finalize
    LibMujs.js_freestate(@j)
  end
end
