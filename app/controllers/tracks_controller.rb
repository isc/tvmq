class TracksController < ApplicationController
  def new; end

  def create
    Track.create data: params[:data].to_unsafe_h
  end
end
