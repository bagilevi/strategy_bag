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

=begin
# generate examples for shared_examples_for_calc:

param_list = 1000.times.to_enum.map do
  [rand(20), rand(30), rand(30)]
end
param_list.sort!
param_list.uniq!

param_list.each do |a, b, c|
  puts "expect(calc(#{a}, #{b}, #{c})).to eq(#{calc(a, b, c).inspect})"
end

=end
