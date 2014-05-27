# encoding: utf-8

class CostCalculator
  class << self
    def calculate(options)
      gas_price = options[:gas_price].to_f
      fuel_consumption = options[:fuel_consumption].to_f
      distance = options[:distance].to_f

      distance*(gas_price/fuel_consumption)
    end
  end
end
