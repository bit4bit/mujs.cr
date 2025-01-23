require "./spec_helper"

describe Mujs do
  it "new_state" do
    j = LibMujs.js_newstate(nil, nil, 0)
    LibMujs.js_freestate(j)
  end

  it "get global variable" do
    j = LibMujs.js_newstate(nil, nil, 0)
    LibMujs.js_dostring(j, "var num = 3;")
    LibMujs.js_dostring(j, %(var str = "hola";))

    LibMujs.js_getglobal(j, "num")
    num = LibMujs.js_tonumber(j, -1)

    LibMujs.js_getglobal(j, "str")
    str = LibMujs.js_tostring(j, -1)
    LibMujs.js_freestate(j)

    num.should eq(3)
    String.new(str).should eq("hola")
  end

  it "success host->js call single argument function" do
    j = LibMujs.js_newstate(nil, nil, 0)
    LibMujs.js_dostring(j, %[function callback(){ return "js" };])

    LibMujs.js_getglobal(j, "callback")
    LibMujs.js_type(j, 0).should eq(LibMujs::JsIsfunction)
    LibMujs.js_pushnull(j)
    LibMujs.js_pcall(j, 0)
    LibMujs.js_type(j, 0).should eq(LibMujs::JsIsstring)
    ret = LibMujs.js_tostring(j, -1)
    LibMujs.js_freestate(j)

    String.new(ret).should eq("js")
  end

  it "success host->js call multi argument function" do
    j = LibMujs.js_newstate(nil, nil, 0)
    LibMujs.js_dostring(j, %[function suma(a, b){ return a + b;  };])

    LibMujs.js_getglobal(j, "suma")
    LibMujs.js_type(j, 0).should eq(LibMujs::JsIsfunction)

    LibMujs.js_pushnull(j)
    LibMujs.js_pushnumber(j, 1)
    LibMujs.js_pushnumber(j, 2)
    LibMujs.js_pcall(j, 2).should eq(0)
    LibMujs.js_type(j, 0).should eq(LibMujs::JsIsnumber)
    ret = LibMujs.js_tonumber(j, -1)
    LibMujs.js_freestate(j)

    ret.should eq(3)
  end

  it "success js->host call function" do
    j = LibMujs.js_newstate(nil, nil, 0)
    cb_num = ->(state : LibMujs::JsState) {
      LibMujs.js_pushnumber(state, 123456)
    }
    LibMujs.js_newcfunction(j, cb_num, "callback_num", 0)
    LibMujs.js_setglobal(j, "callback_num")
    cb_str = ->(state : LibMujs::JsState) {
      # TODO: LibMujs.js_pushtring not working
      LibMujs.js_pushliteral(state, "host")
    }
    LibMujs.js_newcfunction(j, cb_str, "callback_str", 0)
    LibMujs.js_setglobal(j, "callback_str")

    LibMujs.js_dostring(j, %[var result = callback_num();])
    LibMujs.js_getglobal(j, "result")
    ret_num = LibMujs.js_tonumber(j, -1)
    LibMujs.js_getglobal(j, "callback_str")
    LibMujs.js_pushnull(j)
    LibMujs.js_pcall(j, 0)
    GC.collect

    ret_str = LibMujs.js_tostring(j, -1)
    LibMujs.js_freestate(j)

    ret_num.should eq(123456)
    String.new(ret_str).should eq("host")
  end
end
