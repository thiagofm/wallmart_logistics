# encoding: utf-8

require 'spec_helper'

describe MapsController do
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
