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
      expect(LogisticNetParser.parse(logistic_net)).to eq([{:from=>"A", :to=>"B", :distance=>"10"}, {:from=>"B", :to=>"D", :distance=>"1"}, {:from=>"A", :to=>"C", :distance=>"20"}, {:from=>"C", :to=>"D", :distance=>"30"}, {:from=>"B", :to=>"E", :distance=>"50"}, {:from=>"D", :to=>"E", :distance=>"3"}])
    end
  end
end
