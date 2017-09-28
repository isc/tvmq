return unless document.querySelector('#tv-vue')

window.tvVue = new Vue
  el: '#tv-vue'
  data:
    currentTrack: null
    audio: null
    inProgress: false
    players: null
    buzzingPlayer: null
    displayResult: false
    guess: null
    anim: null
  created: ->
    @inProgress = window.vue_data.inProgress
    @players = window.vue_data.players
    @playNextSong() if @inProgress
  methods:
    guessUpdated: (data) -> @guess = data.guess
    gameStarted: ->
      @inProgress = true
      @playNextSong()
    playNextSong: ->
      fetch('/tracks').then((r) -> r.json()).then (data) =>
        @audio = new Audio(data.previewUrl)
        @audio.addEventListener 'playing', =>
          @displayResult = false
          @draw()
          @currentTrack = data
          @currentTrack.releaseYear = data.releaseDate.split('-')[0]
          console.log(data.artistName, data.trackName)
        @audio.play()
        @audio.addEventListener 'ended', @displayResultCard
    displayResultCard: ->
      @displayResult = true
      setTimeout @playNextSong, 10000
    buzzed: (data) ->
      @buzzingPlayer = data.player
      @audio.pause()
    answered: (data) ->
      @buzzingPlayer = null
      Vue.set @players, @players.findIndex((p) -> p.id is data.player.id), data.player
      # playerItem.classList.add('list-group-item-success') if data.track_found || data.artist_found
      @displayResultCard() if data.artist_found && data.track_found
      @audio.play()
    draw: ->
      return if @audio.currentTime is @audio.duration
      α = Math.round(@audio.currentTime / @audio.duration * 360)
      r = (α * Math.PI / 180)
      x = Math.sin(r) * 125
      y = Math.cos(r) * -125
      mid = if α > 180 then 1 else 0
      @anim = "M 0 0 v -125 A 125 125 1 #{mid} 1 #{x} #{y} z"
      setTimeout (=> @draw()), 100
