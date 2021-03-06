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
      expect(route[0]['name']).to eq('A')
      expect(route[1]['distance']).to eq(10.0)
      expect(route[2]['name']).to eq('B')
      expect(route[3]['distance']).to eq(15.0)
      expect(route[4]['name']).to eq('D')
    end
  end

  context '.compute_distance' do
    let!(:route) {
      [
        {"_neo_id"=>1, "name"=>"A", "_classname"=>"Point"},
        {"_neo_id"=>0, "distance"=>10.0},
        {"_neo_id"=>2, "name"=>"B", "_classname"=>"Point"},
        {"_neo_id"=>1, "distance"=>15.0},
        { "_neo_id"=>3, "name"=>"D", "_classname"=>"Point"}
      ]}

    it 'computes the distance of the route' do
      expect(Point.compute_distance(route)).to eq(25.0)
    end
  end

  context '.compute_path' do
    let!(:route) {
      [
        {"_neo_id"=>1, "name"=>"A", "_classname"=>"Point"},
        {"_neo_id"=>0, "distance"=>10.0},
        {"_neo_id"=>2, "name"=>"B", "_classname"=>"Point"},
        {"_neo_id"=>1, "distance"=>15.0},
        { "_neo_id"=>3, "name"=>"D", "_classname"=>"Point"}
      ]}

    it 'computes the distance of the route' do
      expect(Point.compute_path(route)).to eq(["A", "B", "D"])
    end
  end
end
