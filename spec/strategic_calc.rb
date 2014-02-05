require 'strategy_bag'

module StrategicCalc
  extend self

  def calc(a, b, c)
    Solver.new(self, a, b, c).run
  end

  def cmax
    20
  end

  class Solver < StrategyBag
    params :a, :b, :c

    derive(:bc) { b + c }

    condition(:a_high?, :a_low?) { a > 10 }
    condition(:b_high?, :b_low?) { b > 10 }
    condition(:c_high?, :c_low?) { c > 10 }
    condition(:c_max?, :c_not_max?) { c > cmax } # cmax is provided by the interface
    condition(:bc_high?, :bc_low?) { bc > 10 }

    strategy "all high" do
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
