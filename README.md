# transition_through

[![CI](https://github.com/keygen-sh/transition_through/actions/workflows/test.yml/badge.svg)](https://github.com/keygen-sh/transition_through/actions)
[![Gem Version](https://badge.fury.io/rb/transition_through.svg)](https://badge.fury.io/rb/transition_through)

Assert state changes in sequence. Like `change { ... }`, but for asserting
multiple changes in RSpec.

Sponsored by:

<a href="https://keygen.sh?ref=transition_through">
  <div>
    <img src="https://keygen.sh/images/logo-pill.png" width="200" alt="Keygen">
  </div>
</a>

_A fair source software licensing and distribution API._

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'transition_through'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install transition_through
```

## Usage

```ruby
it 'should transition through' do
  expect { counter.increment(3) }.to transition { counter.count }.through 0..3
end
```

## Supported Rubies

**`transition_through` supports Ruby 3.1 and above.** We encourage you to upgrade
if you're on an older version. Ruby 3 provides a lot of great features, like
better pattern matching and a new shorthand hash syntax.

## Is it any good?

Yes.

## Contributing

If you have an idea, or have discovered a bug, please open an issue or create a
pull request.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).