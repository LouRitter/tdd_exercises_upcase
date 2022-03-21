require "rspec/autorun"

DimensionalMismatchError = Class.new(StandardError)
Quantity = Struct.new(:amount, :unit)

class UnitConverter

  def initialize(initial_quantity, target_unit)
    @initial_quantity = initial_quantity
    @target_unit = target_unit

  end

  def convert 
    Quantity.new(
    @initial_quantity.amount * conversion_factor(from: @initial_quantity.unit, to: @target_unit ),
    @target_unit
    )
  end

  private 

  CONVERSION_FACTORS = {
    cup:{
      liter: 0.236588
    }
  }

  def conversion_factor(from:, to:)
    CONVERSION_FACTORS[from][to] || 
      raise(DimensionalMismatchError, "Cant convert from #{from} to #{to}")
  end


end

describe UnitConverter do 
  describe "#convert" do 
    it "translates between 2 units of the same dimension" do
      cups = Quantity.new(2, :cup) 
      converter = UnitConverter.new(cups, :liter)

      result = converter.convert
      expect(result.amount).to be_within(0.001).of(0.473)
      expect(result.unit).to eq(:liter)
    end

    it "raises an error if the two units are not of same dimension" do 
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :gram)
      expect{converter.convert}.to raise_error(DimensionalMismatchError)
    end
  end
end