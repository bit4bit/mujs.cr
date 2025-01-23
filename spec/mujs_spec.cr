require "./spec_helper"

describe Mujs do
  it "instantiate" do
    Mujs.new
  end

  it "host->js call function" do
    js = Mujs.new
    js.dostring(%[function concatenar(a, b){ return a + b; };])
    js.dostring(%[function suma(a, b){ return a + b };])
    js.dostring(%[function mayor_a_1(n) { return n > 1}])
    js.dostring(%[function nulo() { return null; }])

    js.call("suma", 3, 4).should eq(7)
    js.call("suma", 3.3, 4).should eq(7.3)
    js.call("concatenar", "a", "b").should eq("ab")
    js.call("concatenar", "c", "d").should eq("cd")
    js.call("mayor_a_1", 2).should eq(true)
    js.call("mayor_a_1", 0).should eq(false)
    js.call("nulo").should eq(nil)
  end

  it "js->host call function" do
    js = Mujs.new

    js.defn("suma", Int32, Int32) do
      ->(args : Mujs::DefnArguments) {
        return args[0].as(Float64) + args[1].as(Float64)
      }
    end

    js.call("suma", 1, 2).should eq(3)

    js.defn("concatenar", String, String) do
      ->(args : Mujs::DefnArguments) {
        return args[0].as(String) + args[1].as(String)
      }
    end

    js.call("concatenar", "a", "b").should eq("ab")
  end
end
