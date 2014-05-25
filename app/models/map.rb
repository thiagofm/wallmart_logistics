class Map < Neo4j::Rails::Model
  property :name, :type => String, index: :exact

  has_n(:points)
end
