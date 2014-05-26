# encoding: utf-8

require 'spec_helper'

describe Map do
  before(:all) do
    @points = Point.create_points([
      "A B 10",
      "B D 1",
      "A C 20",
      "C D 30",
      "B E 50",
      "D E 3"
    ])
  end

  after(:all) do
    Neo4j.shutdown
    `rm -rf db/neo4j-test/`
  end

  it "creates a map with much points" do
    map = Map.new(name: "Hello")
    map.add_points(@points)
    expect(map.points.outgoing(:route).map do |rel|
      rel['name']
    end).to eq(["A", "B", "C", "D"])
  end

  it "finds the smallest path" do
    map = Map.new(name: "Hello")
    map.add_points(@points)
    expect(map.points.outgoing(:route).map do |rel|
      rel['name']
    end).to eq(["A", "B", "C", "D"])
    map.save

    map = Map.find(name:"Hello")
    point_a = map.points.find{|point| point.name == "A"}
    point_b = map.points.find{|point| point.name == "D"}

    route = Point.route_between(point_a, point_b)
    expect(Point.discover_cost(route)).to eq(11.0)
    expect(Point.discover_route(route)).to eq(["A", "B", "D"])
  end
end
