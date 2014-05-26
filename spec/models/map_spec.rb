# encoding: utf-8

require 'spec_helper'

describe Map do
  before(:all) do
    @points = Point.create_points([
      "A B 10",
      "B D 15",
      "A C 20",
      "C D 30",
      "B E 50",
      "D E 30"
    ])
  end

  after(:all) do
    Neo4j.shutdown
    `rm -rf db/neo4j-test/`
  end

  context '#add_points' do
    it "creates a map with much points" do
      map = Map.new(name: "Hello")
      map.add_points(@points)
      expect(map.points.outgoing(:route).map do |rel|
        rel['name']
      end).to eq(["A", "B", "C", "D"])
    end
  end
end
