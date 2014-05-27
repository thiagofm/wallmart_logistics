class Point < Neo4j::Rails::Model
  property :name, :type => String, index: :exact

  # Creates points for a logistics network
  def self.create_points(logistic_net)
    LogisticNetParser.parse(logistic_net).map do |item|
      from = Point.find_or_create_by(name: item[:from])
      to = Point.find_or_create_by(name: item[:to])
      from.add_route(to, item[:distance])
    end
  end

  # Adds a route between two points with a defined distance
  def add_route(point, distance)
    Neo4j::Transaction.run do
      rel = Neo4j::Relationship.create(:route, self, point)
      rel[:distance] = distance.to_f
    end

    self
  end

  # Calculates a route between point_1 and point_2 with the dijkstra algorithm
  # and the cost being the distance set.
  def self.route_between(point_1, point_2)
    Neo4j::Algo.dijkstra_path(point_1, point_2)
               .outgoing(:route)
               .cost_evaluator{|rel, a, b| rel.props["distance"] }
               .map {|item| item.props }
  end

  # Computes the distance of the route
  def self.compute_distance(route)
    route.select {|route| route['distance'].present? }
         .map    {|route| route['distance'] }
         .reduce(:+)
  end

  # Computes the path needed to go from point_1 to point_2
  def self.compute_path(route)
    route.select {|route| route['name'].present? }
         .map    {|route| route['name'] }
  end
end
