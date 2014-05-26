class Map < Neo4j::Rails::Model
  property :name, :type => String, index: :exact

  has_n(:points)

  def add_points(points)
    points.each do |point|
      self.points << point
    end

    self.save
  end
end
