# Use TDD principles to build out name functionality for a Person.
# Here are the requirements:
# - Add a method to return the full name as a string. A full name includes
#   first, middle, and last name. If the middle name is missing, there shouldn't
#   have extra spaces.
# - Add a method to return a full name with a middle initial. If the middle name
#   is missing, there shouldn't be extra spaces or a period.
# - Add a method to return all initials. If the middle name is missing, the
#   initials should only have two characters.
#
# We've already sketched out the spec descriptions for the #full_name. Try
# building the specs for that method, watch them fail, then write the code to
# make them pass. Then move on to the other two methods, but this time you'll
# create the descriptions to match the requirements above.

class Person
  def initialize(first_name:, middle_name: nil, last_name:)
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  def full_name 
    [@first_name, @middle_name, @last_name].reject(&:nil?).join(" ")

  end
  # implement your behavior here
  def full_name_with_middle_initial
    return [@first_name, @last_name].join(" ") if @middle_name.nil?
    [@first_name, @middle_name[0] + ".", @last_name].reject(&:nil?).join(" ")
  end

  def initials
    return [@first_name[0], @last_name[0]].join(".")+ "." if @middle_name.nil? 
    [@first_name[0], @middle_name[0], @last_name[0]].reject(&:nil?).join(".") + "."
  end
  
end

RSpec.describe Person do
  describe "#full_name" do
    it "concatenates first name, middle name, and last name with spaces" do 
      p = Person.new(first_name: "Lou", middle_name: "Anthony", last_name: "Ritter")
      expect(p.full_name).to eq("Lou Anthony Ritter")
    end
    it "does not add extra spaces if middle name is missing" do 
      p = Person.new(first_name: "Lou", last_name: "Ritter")
      expect(p.full_name).to eq("Lou Ritter")
    
    end
  end

  describe "#full_name_with_middle_initial" do 
    it "returns full name with the middle name as an initial" do 
      p = Person.new(first_name: "Lou", middle_name: "Anthony", last_name: "Ritter")
      expect(p.full_name_with_middle_initial).to eq("Lou A. Ritter")
    end
    it "returns full name without middle initial or period if no middle name" do 
      p = Person.new(first_name: "Lou", last_name: "Ritter")
      expect(p.full_name_with_middle_initial).to eq("Lou Ritter")
    end

  end

  describe "#initials" do 
    it "returns the first letter of the persons first, middle, and last with periods in between" do 
      p = Person.new(first_name: "Lou", middle_name: "Anthony", last_name: "Ritter")
      expect(p.initials).to eq("L.A.R.")
    end
    it "returns the first letter of the persons first and last with periods in between" do 
      p = Person.new(first_name: "Lou" , last_name: "Ritter")
      expect(p.initials).to eq("L.R.")
    end
  end
end