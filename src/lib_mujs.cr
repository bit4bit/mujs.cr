@[Link("mujs")]
lib LibMujs
  JS_VERSION_MAJOR = 1
  JS_VERSION_MINOR = 3
  JS_VERSION_PATCH = 2
  fun js_newstate(alloc : JsAlloc, actx : Pointer(Void), flags : LibC::Int) : JsState
  alias JsAlloc = (Pointer(Void), Pointer(Void), LibC::Int -> Pointer(Void))
  type JsState = Pointer(Void)
  fun js_setcontext(j : JsState, uctx : Pointer(Void))
  fun js_getcontext(j : JsState) : Pointer(Void)
  fun js_setreport(j : JsState, report : JsReport)
  alias JsReport = (JsState, Pointer(LibC::Char) -> Void)
  fun js_atpanic(j : JsState, panic : JsPanic) : JsPanic
  alias JsPanic = (JsState -> Void)
  fun js_freestate(j : JsState)
  fun js_gc(j : JsState, report : LibC::Int)
  fun js_dostring(j : JsState, source : Pointer(LibC::Char)) : LibC::Int
  fun js_dofile(j : JsState, filename : Pointer(LibC::Char)) : LibC::Int
  fun js_ploadstring(j : JsState, filename : Pointer(LibC::Char), source : Pointer(LibC::Char)) : LibC::Int
  fun js_ploadfile(j : JsState, filename : Pointer(LibC::Char)) : LibC::Int
  fun js_pcall(j : JsState, n : LibC::Int) : LibC::Int
  fun js_pconstruct(j : JsState, n : LibC::Int) : LibC::Int
  fun js_savetry(j : JsState) : Pointer(Void)
  fun js_endtry(j : JsState)
  JsStrict = 1_i64
  JsRegexpG = 1_i64
  JsRegexpI = 2_i64
  JsRegexpM = 4_i64
  JsReadonly = 1_i64
  JsDontenum = 2_i64
  JsDontconf = 4_i64
  JsIsundefined = 0_i64
  JsIsnull = 1_i64
  JsIsboolean = 2_i64
  JsIsnumber = 3_i64
  JsIsstring = 4_i64
  JsIsfunction = 5_i64
  JsIsobject = 6_i64
  fun js_report(j : JsState, message : Pointer(LibC::Char))
  fun js_newerror(j : JsState, message : Pointer(LibC::Char))
  fun js_newevalerror(j : JsState, message : Pointer(LibC::Char))
  fun js_newrangeerror(j : JsState, message : Pointer(LibC::Char))
  fun js_newreferenceerror(j : JsState, message : Pointer(LibC::Char))
  fun js_newsyntaxerror(j : JsState, message : Pointer(LibC::Char))
  fun js_newtypeerror(j : JsState, message : Pointer(LibC::Char))
  fun js_newurierror(j : JsState, message : Pointer(LibC::Char))
  fun js_error(j : JsState, fmt : Pointer(LibC::Char), ...)
  fun js_evalerror(j : JsState, fmt : Pointer(LibC::Char), ...)
  fun js_rangeerror(j : JsState, fmt : Pointer(LibC::Char), ...)
  fun js_referenceerror(j : JsState, fmt : Pointer(LibC::Char), ...)
  fun js_syntaxerror(j : JsState, fmt : Pointer(LibC::Char), ...)
  fun js_typeerror(j : JsState, fmt : Pointer(LibC::Char), ...)
  fun js_urierror(j : JsState, fmt : Pointer(LibC::Char), ...)
  fun js_throw(j : JsState)
  fun js_loadstring(j : JsState, filename : Pointer(LibC::Char), source : Pointer(LibC::Char))
  fun js_loadfile(j : JsState, filename : Pointer(LibC::Char))
  fun js_eval(j : JsState)
  fun js_call(j : JsState, n : LibC::Int)
  fun js_construct(j : JsState, n : LibC::Int)
  fun js_ref(j : JsState) : Pointer(LibC::Char)
  fun js_unref(j : JsState, ref : Pointer(LibC::Char))
  fun js_getregistry(j : JsState, name : Pointer(LibC::Char))
  fun js_setregistry(j : JsState, name : Pointer(LibC::Char))
  fun js_delregistry(j : JsState, name : Pointer(LibC::Char))
  fun js_getglobal(j : JsState, name : Pointer(LibC::Char))
  fun js_setglobal(j : JsState, name : Pointer(LibC::Char))
  fun js_defglobal(j : JsState, name : Pointer(LibC::Char), atts : LibC::Int)
  fun js_delglobal(j : JsState, name : Pointer(LibC::Char))
  fun js_hasproperty(j : JsState, idx : LibC::Int, name : Pointer(LibC::Char)) : LibC::Int
  fun js_getproperty(j : JsState, idx : LibC::Int, name : Pointer(LibC::Char))
  fun js_setproperty(j : JsState, idx : LibC::Int, name : Pointer(LibC::Char))
  fun js_defproperty(j : JsState, idx : LibC::Int, name : Pointer(LibC::Char), atts : LibC::Int)
  fun js_delproperty(j : JsState, idx : LibC::Int, name : Pointer(LibC::Char))
  fun js_defaccessor(j : JsState, idx : LibC::Int, name : Pointer(LibC::Char), atts : LibC::Int)
  fun js_getlength(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_setlength(j : JsState, idx : LibC::Int, len : LibC::Int)
  fun js_hasindex(j : JsState, idx : LibC::Int, i : LibC::Int) : LibC::Int
  fun js_getindex(j : JsState, idx : LibC::Int, i : LibC::Int)
  fun js_setindex(j : JsState, idx : LibC::Int, i : LibC::Int)
  fun js_delindex(j : JsState, idx : LibC::Int, i : LibC::Int)
  fun js_currentfunction(j : JsState)
  fun js_currentfunctiondata(j : JsState) : Pointer(Void)
  fun js_pushglobal(j : JsState)
  fun js_pushundefined(j : JsState)
  fun js_pushnull(j : JsState)
  fun js_pushboolean(j : JsState, v : LibC::Int)
  fun js_pushnumber(j : JsState, v : LibC::Double)
  fun js_pushstring(j : JsState, v : Pointer(LibC::Char))
  fun js_pushlstring(j : JsState, v : Pointer(LibC::Char), n : LibC::Int)
  fun js_pushliteral(j : JsState, v : Pointer(LibC::Char))
  fun js_newobjectx(j : JsState)
  fun js_newobject(j : JsState)
  fun js_newarray(j : JsState)
  fun js_newboolean(j : JsState, v : LibC::Int)
  fun js_newnumber(j : JsState, v : LibC::Double)
  fun js_newstring(j : JsState, v : Pointer(LibC::Char))
  fun js_newcfunction(j : JsState, fun : JsCFunction, name : Pointer(LibC::Char), length : LibC::Int)
  alias JsCFunction = (JsState -> Void)
  fun js_newcfunctionx(j : JsState, fun : JsCFunction, name : Pointer(LibC::Char), length : LibC::Int, data : Pointer(Void), finalize : JsFinalize)
  alias JsFinalize = (JsState, Pointer(Void) -> Void)
  fun js_newcconstructor(j : JsState, fun : JsCFunction, con : JsCFunction, name : Pointer(LibC::Char), length : LibC::Int)
  fun js_newuserdata(j : JsState, tag : Pointer(LibC::Char), data : Pointer(Void), finalize : JsFinalize)
  fun js_newuserdatax(j : JsState, tag : Pointer(LibC::Char), data : Pointer(Void), has : JsHasProperty, put : JsPut, del : JsDelete, finalize : JsFinalize)
  alias JsHasProperty = (JsState, Pointer(Void), Pointer(LibC::Char) -> LibC::Int)
  alias JsPut = (JsState, Pointer(Void), Pointer(LibC::Char) -> LibC::Int)
  alias JsDelete = (JsState, Pointer(Void), Pointer(LibC::Char) -> LibC::Int)
  fun js_newregexp(j : JsState, pattern : Pointer(LibC::Char), flags : LibC::Int)
  fun js_pushiterator(j : JsState, idx : LibC::Int, own : LibC::Int)
  fun js_nextiterator(j : JsState, idx : LibC::Int) : Pointer(LibC::Char)
  fun js_isdefined(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isundefined(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isnull(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isboolean(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isnumber(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isstring(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isprimitive(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isobject(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isarray(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isregexp(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_iscoercible(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_iscallable(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isuserdata(j : JsState, idx : LibC::Int, tag : Pointer(LibC::Char)) : LibC::Int
  fun js_iserror(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isnumberobject(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isstringobject(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isbooleanobject(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_isdateobject(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_toboolean(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_tonumber(j : JsState, idx : LibC::Int) : LibC::Double
  fun js_tostring(j : JsState, idx : LibC::Int) : Pointer(LibC::Char)
  fun js_touserdata(j : JsState, idx : LibC::Int, tag : Pointer(LibC::Char)) : Pointer(Void)
  fun js_trystring(j : JsState, idx : LibC::Int, error : Pointer(LibC::Char)) : Pointer(LibC::Char)
  fun js_trynumber(j : JsState, idx : LibC::Int, error : LibC::Double) : LibC::Double
  fun js_tryinteger(j : JsState, idx : LibC::Int, error : LibC::Int) : LibC::Int
  fun js_tryboolean(j : JsState, idx : LibC::Int, error : LibC::Int) : LibC::Int
  fun js_tointeger(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_toint32(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_touint32(j : JsState, idx : LibC::Int) : LibC::UInt
  fun js_toint16(j : JsState, idx : LibC::Int) : LibC::Short
  fun js_touint16(j : JsState, idx : LibC::Int) : LibC::UShort
  fun js_gettop(j : JsState) : LibC::Int
  fun js_pop(j : JsState, n : LibC::Int)
  fun js_rot(j : JsState, n : LibC::Int)
  fun js_copy(j : JsState, idx : LibC::Int)
  fun js_remove(j : JsState, idx : LibC::Int)
  fun js_insert(j : JsState, idx : LibC::Int)
  fun js_replace(j : JsState, idx : LibC::Int)
  fun js_dup(j : JsState)
  fun js_dup2(j : JsState)
  fun js_rot2(j : JsState)
  fun js_rot3(j : JsState)
  fun js_rot4(j : JsState)
  fun js_rot2pop1(j : JsState)
  fun js_rot3pop2(j : JsState)
  fun js_concat(j : JsState)
  fun js_compare(j : JsState, okay : Pointer(LibC::Int)) : LibC::Int
  fun js_equal(j : JsState) : LibC::Int
  fun js_strictequal(j : JsState) : LibC::Int
  fun js_instanceof(j : JsState) : LibC::Int
  fun js_typeof(j : JsState, idx : LibC::Int) : Pointer(LibC::Char)
  fun js_type(j : JsState, idx : LibC::Int) : LibC::Int
  fun js_repr(j : JsState, idx : LibC::Int)
  fun js_torepr(j : JsState, idx : LibC::Int) : Pointer(LibC::Char)
  fun js_tryrepr(j : JsState, idx : LibC::Int, error : Pointer(LibC::Char)) : Pointer(LibC::Char)
end
