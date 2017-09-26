class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception

  def current_player
    @current_player ||= Player.find_by id: session[:player_id] if session[:player_id]
  end

  def current_game
    Game.where.not(state: 'ended').first || Game.create(state: 'lobby')
  end
end
