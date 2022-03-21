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
    liter:{
      cup: 4.22675,
      pint: 2.11338, 
      liter: 1,  
    },
    gram: {
      kilogram: 0.001, 
      gram: 1
    }
  }

  def conversion_factor(from:, to:)
    dimension = common_dimension(from, to) ||
      raise(DimensionalMismatchError, "Cant convert from #{from} to #{to}")
    CONVERSION_FACTORS[dimension][to] / CONVERSION_FACTORS[dimension][from]

  end

  def common_dimension(from, to)
    CONVERSION_FACTORS.keys.find do |canonical_unit|
      CONVERSION_FACTORS[canonical_unit].keys.include?(from) &&
      CONVERSION_FACTORS[canonical_unit].keys.include?(to)
    end
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

    it "translates between 2 units of the same dimension (gram & kg)" do
      kg = Quantity.new(2, :kilogram) 
      converter = UnitConverter.new(kg, :gram)

      result = converter.convert
      expect(result.amount).to be_within(0.001).of(2000)
      expect(result.unit).to eq(:gram)
    end

    it "raises an error if the two units are not of same dimension" do 
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :gram)
      expect{converter.convert}.to raise_error(DimensionalMismatchError)
    end

    it "returns itself when given 2 of the same unit types" do 
      cups = Quantity.new(2, :cup)
      converter = UnitConverter.new(cups, :cup)
      result = converter.convert
      expect(result.amount).to be_within(0.001).of(2)
      expect(result.unit).to eq(:cup)
    end
  end
end