class GamesController < ApplicationController
  def index
    return redirect_to(new_player_path) unless current_player
    fetch_game_and_players
  end

  def tv
    fetch_game_and_players
  end

  def update
    ActionCable.server.broadcast('game', event: 'game_start')
    Game.find(params[:id]).update! state: 'in_progress'
    head :no_content
  end

  def answer
    evaluation = current_game.evaluate params[:value]
    ActionCable.server.broadcast('game', evaluation.merge(event: 'answer', player: current_player))
    current_player.score += evaluation[:points]
    current_player.save
    head :no_content
  end

  def buzz
    if Game.where(id: current_game.id, buzzing_player_id: nil).update_all(buzzing_player_id: current_player.id) == 1
      ActionCable.server.broadcast('game', event: 'buzz', player: current_player)
      render json: true
    else
      render json: false
    end
  end

  private

  def fetch_game_and_players
    @game = current_game
    @players = Player.all
  end
end
