require_relative 'calc'
require_relative 'shared_examples_for_calc'

describe Calc do
  include Calc

  it_should_behave_like "calc"
end
