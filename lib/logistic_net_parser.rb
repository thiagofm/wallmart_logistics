# encoding: utf-8

class LogisticNetParser
  class << self
    def parse(net)
      net.map do |item|
        item = item.split(" ")
        {from: item[0], to: item[1], distance: item[3]}
      end
    end
  end
end
