# encoding: utf-8

class MapsController < ApplicationController
  def create
    map = Map.new(name: params[:name])
    map.add_points(Point.create_points(params[:logistic_net]))
    map.save

    render status: 200, nothing: true
  end
end
