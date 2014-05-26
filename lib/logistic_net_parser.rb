# encoding: utf-8

class LogisticNetParser
  class << self
    def parse(net)
      net.map {|item| item = item.split(" ") }
         .map {|item| {from: item[0], to: item[1], distance: item[2]} }
    end
  end
end
