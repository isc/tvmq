return unless document.querySelector('#player-vue')

window.playerVue = new Vue
  el: '#player-vue'
  data:
    inProgress: false
    player: null
    players: null
    answering: false
    buzzerDisabled: false
    answer: null
    playing: false
  created: ->
    @inProgress = window.vue_data.inProgress
    @player = window.vue_data.player
    @players = window.vue_data.players
    @quack = new Audio '/Quack.mp3'
  watch:
    answer: (value) -> App.gameChannel.send event: 'guessing', guess: value
  methods:
    play: -> @playing = true
    buzzed: -> @buzzerDisabled = true
    answered: (data) ->
      @buzzerDisabled = data.player.id is @player.id
      @playing = false if data.track_done
    gameStarted: -> @inProgress = true
    startGame: (event) -> fetch(event.target.action, method: 'PUT')
    buzz: (event) ->
      @buzzerDisabled = true
      fetch event.target.action,
        method: 'POST'
        headers: {'Content-Type': 'application/json'}
        credentials: 'same-origin'
      .then((r) -> r.json()).then (data) =>
        @answering = data
        return unless @answering
        setTimeout (=> @$refs.answer.focus()), 0
        @answerTimeout = setTimeout (=> @sendAnswer(target: @$refs.answerForm)), 15000
      @quack.play()
    sendAnswer: (event) ->
      clearTimeout @answerTimeout
      fetch event.target.action,
        method: 'POST'
        body: JSON.stringify value: @answer
        headers: {'Content-Type': 'application/json'}
        credentials: 'same-origin'
      @answering = false
      @buzzerDisabled = true
      @answer = null
      setTimeout (=> @buzzerDisabled = false), 3000
