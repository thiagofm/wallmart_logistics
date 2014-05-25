class Point < Neo4j::Rails::Model
  property :name, :type => String, index: :exact

  # Adds a route between two points with a defined distance
  def add_route(point, distance)
    Neo4j::Transaction.run do
      rel = Neo4j::Relationship.create(:route, self, point)
      rel[:distance] = distance
    end

    self
  end

  def self.route_between(point_1, point_2)
    Neo4j::Algo.dijkstra_path(point_1, point_2)
               .outgoing(:route)
               .cost_evaluator{|rel, a, b| rel.props["distance"].to_f }
  end
end
