# encoding: utf-8

require 'spec_helper'

describe CostCalculator do
  context '.calculate' do
    it "calculates the cost of the route based on it's distance" do
      expect(CostCalculator.calculate(
        gas_price: "2.5",
        fuel_consumption: "10",
        distance: "25"
      )).to eq(6.25)
    end
  end
end
