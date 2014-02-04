# StrategyBag

[![Gem Version](https://badge.fury.io/rb/strategy_bag.png)](http://badge.fury.io/rb/strategy_bag)
[![Build Status](https://travis-ci.org/bagilevi/strategy_bag.png)](https://travis-ci.org/bagilevi/strategy_bag)
[![Code Climate](https://codeclimate.com/github/bagilevi/strategy_bag.png)](https://codeclimate.com/github/bagilevi/strategy_bag)


Ruby DSL for making conditionals more readable by defining a set of strategies. Each strategy has a set of conditions and an action. The runner will select a strategy that meets the conditions and executes it.

## Installation

Add this line to your application's Gemfile:

    gem 'strategy_bag'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strategy_bag

## Example

Before:

```ruby
module Calc
  extend self

  def calc(a, b, c)
    if a > 10
      if b > 10
        if c > 10
          a + b - 2 * c
        else
          a + b + c
        end
      else
        if c > 20
          a + b - c
        else
          a + b + c
        end
      end
    else
      if b + c > 10
        b + c - a
      end
    end
  end
end
```

After:

```ruby
require 'strategy_bag'

module StrategicCalc
  extend self

  def calc(a, b, c)
    Solver.new(a, b, c).run
  end

  class Solver < StrategyBag
    params :a, :b, :c

    condition(:a_high?, :a_low?) { a > 10 }
    condition(:b_high?, :b_low?) { b > 10 }
    condition(:c_high?, :c_low?) { c > 10 }
    condition(:c_max?, :c_not_max?) { c > 20 }
    condition(:bc_high?, :bc_low?) { b + c > 10 }

    strategy do
      condition :a_high?
      condition :b_high?
      condition :c_high?
      action do
        a + b - 2 * c
      end
    end

    strategy do
      condition :a_high?
      condition :b_high?
      condition :c_low?
      action do
        a + b + c
      end
    end

    strategy do
      condition :a_high?
      condition :b_low?
      condition :c_max?
      action do
        a + b - c
      end
    end

    strategy do
      condition :a_high?
      condition :b_low?
      condition :c_not_max?
      action do
        a + b + c
      end
    end

    strategy do
      condition :a_low?
      condition :bc_high?
      action do
        b + c - a
      end
    end

    default do
      nil
    end

  end
end
```


## Contributing

1. Fork it ( http://github.com/bagilevi/strategy_bag/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

