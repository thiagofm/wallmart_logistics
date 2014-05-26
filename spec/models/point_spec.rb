# encoding: utf-8

require 'spec_helper'

describe Point do
  context '.create_points' do
    before(:all) do
      Point.create_points([
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

    it 'creates points' do
      expect(Point.find(name: "A")).to_not eq(nil)
    end

    it 'adds relation from one point to another' do
      rels = Point.find(name: "A").outgoing(:route).map do |rel|
        rel['name']
      end
      expect(rels).to eq(["B", "C"])
    end

    it "'s relation has the right distance" do
      expect(Point.find(name: "A").rels(:outgoing, :route).first[:distance]).to eq(10.0)
    end
  end

  context '.route_between' do
    before(:all) do
      @points = Point.create_points([
        "A B 10",
        "B D 15",
        "A C 20",
        "C D 30",
        "B E 50",
        "D E 30"
      ])
      map = Map.new(name: "Hello")
      map.add_points(@points)
      map.save

      map = Map.find(name:"Hello")
      @point_a = map.points.find{|point| point.name == "A"}
      @point_b = map.points.find{|point| point.name == "D"}
    end

    after(:all) do
      Neo4j.shutdown
      `rm -rf db/neo4j-test/`
    end

    it 'calculates a route between point a & b' do
      route = Point.route_between(@point_a, @point_b)
      expect(Point.compute_distance(route)).to eq(25.0)
      expect(Point.compute_path(route)).to eq(["A", "B", "D"])
    end
  end
end
