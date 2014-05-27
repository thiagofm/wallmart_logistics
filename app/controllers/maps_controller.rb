# encoding: utf-8

class MapsController < ApplicationController
  def create
    map = Map.new(name: params[:name])
    map.add_points(Point.create_points(params[:logistic_net]))
    map.save

    render status: 200, nothing: true
  end

  def path
    map = Map.find(name: params[:map_id])

    point_a = map.points.find{|point| point.name == params[:from]}
    point_b = map.points.find{|point| point.name == params[:to]}

    route = Point.route_between(point_a, point_b)

    render status: 200, json: {
      price: CostCalculator.calculate(
        gas_price: params[:gas_price],
        fuel_consumption: params[:fuel_consumption],
        distance: Point.compute_distance(route)
      ),
      path: Point.compute_path(route),
    }
  end
end
