require "./lib_mujs"

class Mujs
  VERSION = "0.1.0"

  class Opaque(T)
    def self.box(js, object : T) : UInt64
      hash = object.hash
      js.opaque[hash] = Box(T).box(object)
      hash
    end

    def self.unbox(js, hash : Mujs::DefnReturn) : T
      hash = hash.as(Float64)
      val = Box(T).unbox(js.opaque[hash])
      js.opaque.delete(hash)
      val
    end
  end

  alias DefnArguments = Hash(Int32, Bool | UInt64 | Float64 | String | Nil)
  alias DefnReturn = Bool | UInt64 | Float64 | String | Nil

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
    when Bool
      LibMujs.js_pushboolean(state, {{val}})
    when UInt64
      LibMujs.js_pushnumber(state, {{val}})
    when Float64
      LibMujs.js_pushnumber(state, {{val}})
    when Int32
      LibMujs.js_pushnumber(state, {{val}})
    when String
      LibMujs.js_pushstring(state, {{val}})
    when nil
      LibMujs.js_pushnull(state)
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
    when LibMujs::JsIsobject
      # TODO: pop as hash
      pop_as_string
    else
      raise "unknow how to cast javascript type #{_js_type}"
    end
  end

  property opaque : Hash(UInt64, Pointer(Void))

  def initialize
    @j = LibMujs.js_newstate(nil, nil, 0)
    @opaque = Hash(UInt64, Pointer(Void)).new
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
        when Bool
          LibMujs.js_pushboolean(@j, arg == true ? 1 : 0)
        when UInt64
          LibMujs.js_pushnumber(@j, arg)
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

  def var(name)
    LibMujs.js_getglobal(@j, name)
    pop_and_cast
  end

  @@functions = Hash({Mujs, String}, Pointer(Void)).new

  def defn(fn_name, fn_num_args, &capture : (DefnArguments -> DefnReturn))
    boxed_data = Box.box({capture, fn_num_args})

    # avoid GC collector
    @@functions[{self, fn_name}] = boxed_data

    LibMujs.js_newcfunctionx(@j,
      ->(state) {
        data = LibMujs.js_currentfunctiondata(state)
        fn, fn_arity = Box(typeof({capture, fn_num_args})).unbox(data)

        args = DefnArguments.new
        fn_arity.times do |idx|
          arg_idx = idx + 1
          arg_key = idx

          arg_js_type = LibMujs.js_type(state, arg_idx)
          case arg_js_type
          when LibMujs::JsIsnumber
            args[arg_key] = LibMujs.js_tonumber(state, arg_idx)
          when LibMujs::JsIsstring
            args[arg_key] = String.new(LibMujs.js_tostring(state, arg_idx))
          when LibMujs::JsIsnull
            args[arg_key] = nil
          else
            raise "uknown how to handle argument type #{arg_js_type}"
          end
        end

        begin
          res = fn.call(args)
          cast_and_push(res)
        rescue ex
          # TODO: improv
          LibMujs.js_error(state, "HOST EXCEPTION: #{ex.inspect_with_backtrace}")
          LibMujs.js_throw(state)
        end
      }, fn_name,
      fn_num_args, boxed_data, nil)
    LibMujs.js_setglobal(@j, fn_name)
  end

  def finalize
    LibMujs.js_freestate(@j)
  end
end
