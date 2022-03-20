require "rspec/autorun"
#calc = Calculator.new
#calc.add(5,10) # => 15
class Calculator

  def add(a, b)
    a+b
  end


end
describe Calculator do 
  describe "#add" do
    it "returns the sum of its arguments" do
      calc = Calculator.new
      expect(calc.add(5,10)).to eq(15)
    end

    it "returns the sum of two different arguments" do
      calc = Calculator.new
      expect(calc.add(3,4)).to eq(7)
    end
  end
end
