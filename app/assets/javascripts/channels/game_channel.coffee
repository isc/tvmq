App.gameChannel = App.cable.subscriptions.create { channel: 'GameChannel' },
  received: (data) ->
    component = window.playerVue || window.tvVue
    return unless component
    component.players.push data.player if data.event is 'new_player'
    component.gameStarted() if data.event is 'game_start'
    component.buzzed(data) if data.event is 'buzz'
    component.answered(data) if data.event is 'answer'
    component.guessUpdated(data) if data.event is 'guessing' and component.guessUpdated
    component.play() if data.event is 'play' and component.play
    component.pause() if data.event is 'pause' and component.pause
