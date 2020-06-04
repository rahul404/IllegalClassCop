# IllegalClassCop

IllegalClassCop is a rake task that list all usage of class, modules and constants which don't belong to current engine.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'illegal_class_cop', github: 'rahul404/IllegalClassCop'
```

And then execute:

    $ bundle install

## Usage

To invoke the utility on all engines, 
```
 rake illegal_class_cop
```
To invoke the utility on specific engines, 
```
 rake illegal_class_cop engine_1, engine_2
```

Example:
```
rake illegal_class_cop textract
```
Output:
```dockerfile
1. Constant User illegally accessed in /Users/apple/gocomet/gocomet-app/apps/invoice/spec/interfaces/textract/name_mapper_spec.rb
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rahul404/IllegalClassCop.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
