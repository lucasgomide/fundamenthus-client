# Fundamenthus

Keep updated about the stocks' fundamentals is essential. This gem export brazilian stock data from the best ones stock analysis websites in JSON format. *You can export in CSV, HTML format soon.*

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fundamenthus-client'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install fundamenthus-client


## Usage


You can export the stock fundamentals and earnings from the following sources:


| Source | Fundamentals | Earnings |
| ------ | ------ | ------ |
| [statusinvest.com.br](http://statusinvest.com.br) | ✓ | 𐄂 |
| [fundamentus.com.br](http://fundamentus.com.br) | ✓ | 𐄂 |
| [b3.com.br](http://b3.com.br) | 𐄂 | ✓ |

𐄂 not available  ✓ available





### Retrieve information

To get the stock's earnings and its fundamentals just call `.earnings` and `.stocks` respectively. Check out the follow examples.

[fundamentus.com.br](http://fundamentus.com.br)
```ruby
# Retrieve fundamentals data
Fundamenthus::Source::Fundamentus.stocks

# Retrieve earnings data
Fundamenthus::Source::Fundamentus.earnings
```

[statusinvest.com.br](http://statusinvest.com.br)
```ruby
# Retrieve fundamentals data
Fundamenthus::Source::StatusInvest.stocks

# Retrieve earnings data
Fundamenthus::Source::StatusInvest.earnings
```

[b3.com.br](http://b3.com.br)
```ruby
# Retrieve fundamentals data
Fundamenthus::Source::StatusInvest.stocks

# Retrieve earnings data
Fundamenthus::Source::StatusInvest.earnings
```

### Format supporting

The default format is [Hash](https://ruby-doc.org/core-2.5.1/Hash.html). You will be able to export to others formats such as: `CSV` and `HTML` soon.

For while, the output is always Hash Object

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bundle console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lucasgomide/fundamenthus-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/lucasgomide/fundamenthus-client/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fundamenthus project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/lucasgomide/fundamenthus-client/blob/master/CODE_OF_CONDUCT.md).
