class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game'
  end

  def receive data
    ActionCable.server.broadcast('game', data)
  end
end
