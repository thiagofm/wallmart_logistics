# encoding: utf-8

require 'spec_helper'

describe Point do
  context '.create_points' do
    before(:all) do
      Point.create_points([
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
end
