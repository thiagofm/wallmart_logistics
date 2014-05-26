class Point < Neo4j::Rails::Model
  property :name, :type => String, index: :exact

  # Adds a route between two points with a defined distance
  def add_route(point, distance)
    Neo4j::Transaction.run do
      rel = Neo4j::Relationship.create(:route, self, point)
      rel[:distance] = distance.to_f
    end

    self
  end


  def self.route_between(point_1, point_2)
    Neo4j::Algo.dijkstra_path(point_1, point_2)
               .outgoing(:route)
               .cost_evaluator{|rel, a, b| rel.props["distance"] }
               .map {|item| item.props }
  end

  def self.create_points(logistic_net)
    LogisticNetParser.parse(logistic_net).map do |item|
      from = Point.find_or_create_by(name: item[:from])
      to = Point.find_or_create_by(name: item[:to])
      from.add_route(to, item[:distance])
    end
  end

  def self.discover_cost(route)
    route.select {|route| route['distance'].present? }
         .map    {|route| route['distance'] }
         .reduce(:+)
  end

  def self.discover_route(route)
    route.select {|route| route['name'].present? }
         .map    {|route| route['name'] }
  end
end
