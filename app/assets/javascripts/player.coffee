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
  created: ->
    @inProgress = window.vue_data.inProgress
    @player = window.vue_data.player
    @players = window.vue_data.players
  watch:
    answer: (value) ->
      App.gameChannel.send event: 'guessing', guess: value
  methods:
    buzzed: (data) -> @buzzerDisabled = data.player.id is @player.id
    answered: -> @buzzerDisabled = false
    gameStarted: -> @inProgress = true
    startGame: (event) -> fetch(event.target.action, method: 'PUT')
    buzz: ->
      App.gameChannel.send event: 'buzz', player: @player
      @answering = true
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
