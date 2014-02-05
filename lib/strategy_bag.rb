class StrategyBag

  def initialize(*args)
    @evaluator = Evaluator.new
    self.class.param_names.each_with_index do |name, index|
      @evaluator.define_value name, args[index]
    end
  end

  def run
    self.class.derived_attributes.each do |name, block|
      @evaluator.define_func name, block
    end
    self.class.conditions.each do |positive_name, negative_name, p|
      @evaluator.define_func positive_name, p
      @evaluator.define_negative negative_name, positive_name
    end
    satisfied_strategies = self.class.strategies.select { |strategy|
      @evaluator.conditions_met?(strategy.conditions)
    }
    selected_strategy = satisfied_strategies.first
    if selected_strategy
      @evaluator.instance_eval(&selected_strategy.action)
    else
      @evaluator.instance_eval(&(self.class.default_strategy))
    end
  end

  private


  class Evaluator
    def initialize
      @table = {}
    end

    def define_value(name, value)
      #puts "E: #{name}: #{value.inspect}"
      @table[name.to_sym] = value
    end

    def define_func(name, p)
      v = instance_eval(&p)
      define_value(name, v)
    end

    def define_negative(name, positive_name)
      define_value(name, ! send(positive_name))
    end

    def conditions_met?(a)
      a.all? { |c| send(c) }
    end

    def method_missing(m, *args, &proc)
      #puts "missing: #{m}"
      if @table.has_key?(m.to_sym) && args.empty?
        @table[m.to_sym]
      else
        super
      end
    end
  end

  module ClassDSL
    attr_accessor :param_names, :conditions, :strategies, :default_strategy, :derived_attributes

    def params(*param_names)
      self.param_names = param_names
    end

    def condition(positive_name, negative_name, &p)
      #puts "DSL: condition: #{positive_name}"
      self.conditions ||= []
      self.conditions << [positive_name, negative_name, p]
    end

    def strategy(&block)
      self.strategies ||= []
      strategy = Strategy.new
      strategy.instance_eval(&block)
      self.strategies << strategy
    end

    def default(&block)
      self.default_strategy = block
    end

    def derive(name, &block)
      self.derived_attributes ||= []
      self.derived_attributes << [name, block]
    end

  end

  extend ClassDSL

  class Strategy
    attr_accessor :conditions, :action

    def initialize
      @conditions = []
    end

    def condition(name)
      @conditions << name
    end

    def action(&block)
      if block_given?
        @action = block
      else
        @action
      end
    end
  end
end
