class PlayersController < ApplicationController
  def create
    player = Player.create! params.permit(:name)
    session[:player_id] = player.id
    cookies[:player_name] = player.name
    ActionCable.server.broadcast('game', event: 'new_player', player: player)
    redirect_to '/'
  end
end
