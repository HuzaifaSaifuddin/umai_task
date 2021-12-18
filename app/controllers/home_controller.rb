class HomeController < ApplicationController
  def index
    render json: 'Its working!'
  end
end
