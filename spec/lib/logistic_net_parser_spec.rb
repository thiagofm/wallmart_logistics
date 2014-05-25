# encoding: utf-8

require 'spec_helper'

describe LogisticNetParser do
  context '.parse' do
    let(:logistic_net) {[
      "A B 10",
      "B D 1",
      "A C 20",
      "C D 30",
      "B E 50",
      "D E 3"
    ]}

    it "parses correctly" do
      expect(LogisticNetParser.parse(logistic_net)).to be(true)
    end
  end
end
