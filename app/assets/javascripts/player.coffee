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
  watch:
    answer: (value) -> App.gameChannel.send event: 'guessing', guess: value
  methods:
    pause: -> @playing = false
    play: -> @playing = true
    buzzed: -> @buzzerDisabled = true
    answered: (data) -> @buzzerDisabled = data.player.id is @player.id
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
    sendAnswer: (event) ->
      fetch event.target.action,
        method: 'POST'
        body: JSON.stringify value: @answer
        headers: {'Content-Type': 'application/json'}
        credentials: 'same-origin'
      @answering = false
      @buzzerDisabled = true
      @answer = null
      setTimeout (=> @buzzerDisabled = false), 2000
