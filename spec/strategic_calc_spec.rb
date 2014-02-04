require_relative 'strategic_calc'
require_relative 'shared_examples_for_calc'

describe StrategicCalc do
  include StrategicCalc

  it_should_behave_like "calc"
end

