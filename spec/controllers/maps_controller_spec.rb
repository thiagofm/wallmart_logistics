# encoding: utf-8

require 'spec_helper'

describe MapsController do
  context 'GET #path' do
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
    end

    after(:all) do
      Neo4j.shutdown
      `rm -rf db/neo4j-test/`
    end

    it "responds correctly" do
      get :path, map_id: "Hello", from: "A", to: "D", fuel_consumption: "10", gas_price: "2.50", format: :json
      response.status.should be 200

      json_response = JSON.parse(response.body)
      expect(json_response['price']).to eq(6.25)
      expect(json_response['path']).to eq(['A', 'B', 'D'])
    end
  end

  context 'POST #create' do
    let(:logistic_net) {[
        "A B 10",
        "B D 15",
        "A C 20",
        "C D 30",
        "B E 50",
        "D E 30"]}

    after(:all) do
      Neo4j.shutdown
      `rm -rf db/neo4j-test/`
    end

    it "responds correctly" do
      post :create, name: "Hello", logistic_net: logistic_net, format: :json
      response.status.should be 200
    end

    it "creates a new map" do
      expect(Map.find(name: "Hello")).to_not be nil
    end
  end
end
