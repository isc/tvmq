class TracksController < ApplicationController
  def new; end

  def index
    render json: current_game.next_track.data
  end

  def create
    Track.create data: params[:data].to_unsafe_h
  end
end
