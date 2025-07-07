require "uri"
require "./spec_helper"

describe Mujs do
  it "instantiate" do
    Mujs.new
  end

  it "has_function?" do
    js = Mujs.new
    js.dostring(%[function funcion() { }])

    js.has_function?("funcion").should eq(true)
    js.has_function?("invalid").should eq(false)
  end

  it "host->js call function" do
    js = Mujs.new
    js.dostring(%[function concatenar(a, b){ return a + b; };])
    js.dostring(%[function suma(a, b){ return a + b };])
    js.dostring(%[function mayor_a_1(n) { return n > 1}])
    js.dostring(%[function negacion(v){ return !v; }])
    js.dostring(%[function nulo() { return null; }])

    js.call("suma", 3, 4).should eq(7)
    js.call("suma", 3.3, 4).should eq(7.3)
    js.call("negacion", false).should eq(true)
    js.call("concatenar", "a", "b").should eq("ab")
    js.call("concatenar", "c", "d").should eq("cd")
    js.call("mayor_a_1", 2).should eq(true)
    js.call("mayor_a_1", 0).should eq(false)
    js.call("nulo").should eq(nil)
  end

  it "host->js var" do
    js = Mujs.new
    js.defvar("varnum", 1)
    js.defvar("varbool", false)
    js.defvar("varstring", "hola")
    js.defvar("varfloat", 1.65)
    js.defvar("varnull", nil)

    js.var("varnum").should eq(1)
    js.var("varbool").should eq(false)
    js.var("varstring").should eq("hola")
    js.var("varfloat").should eq(1.65)
    js.var("varnull").should eq(nil)
  end

  it "host->js sharing opaque resource" do
    opaque = Hash(UInt64, Pointer(Void)).new
    js = Mujs.new

    js.defn("do_uri", 1) do |args|
      Mujs::Opaque.box(js, URI.parse(args[0].as(String)))
    end

    js.dostring(%[function uri(url){ return do_uri(url); };])

    ret = js.call("uri", "http://localhost")

    uri = Mujs::Opaque(URI).unbox(js, ret)
    uri.host.should eq "localhost"
  end

  it "js->host call function" do
    js = Mujs.new

    js.defn("suma", 2) do |args|
      args[0].as(Float64) + args[1].as(Float64)
    end

    js.call("suma", 1, 2).should eq(3)

    js.defn("concatenar", 2) do |args|
      args[0].as(String) + args[1].as(String)
    end

    js.call("concatenar", "a", "b").should eq("ab")

    js.defn("nulo", 0) do |args|
      nil
    end

    js.call("nulo").should eq(nil)
  end

  it "js->host call function exception on javascript side" do
    js = Mujs.new

    js.defn("exception", 0) do |args|
      raise "exception host"
      nil
    end

    expect_raises(Exception) do
      js.call("exception").should eq("ab")
    end

    js.dostring(%[try{exception();}catch(e){var err = e;}])
    js.var("err").as(String).includes?("exception host").should eq(true)
  end
end
