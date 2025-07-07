# mujs

Crystal Lang embedded Javascript interpreter using MuJS.


## Example

```crystal
require "mujs"

js = Mujs.new

js.defn("print", 1) do |args|
  puts args[0].as(String)
end

js.dostring(%[print("hello world")])
```

more examples at `spec/mujs_spec.cr`.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     mujs:
       github: bit4bit/mujs.cr
   ```

2. Run `shards install`

## Usage

see `spec/mujs_spec.cr`

## Development

* [Documentation](https://mujs.com/introduction.html)

## Contributing

1. Fork it (<https://github.com/bit4bit/mujs.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jovany Leandro G.C](https://github.com/bit4bit) - creator and maintainer
