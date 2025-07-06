require "../src/mujs"

js = Mujs.new

js.defn("print", 1) do |args|
  puts(args[0].as(String))
end

js.dostring(ARGF.gets_to_end)
