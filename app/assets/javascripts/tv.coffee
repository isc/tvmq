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
    @audio = document.getElementById('player')
    @audio.addEventListener 'playing', @draw
    @audio.addEventListener 'ended', @displayResultCard
  methods:
    artistName: -> if @currentTrack?.artistFound or @displayResult then @currentTrack.artistName else '?'
    trackName: -> if @currentTrack?.trackFound or @displayResult then @currentTrack.trackName else '?'
    guessUpdated: (data) -> @guess = data.guess
    gameStarted: ->
      @inProgress = true
      @playNextSong()
    playNextSong: ->
      fetch('/tracks').then((r) -> r.json()).then (data) =>
        @audio.src = data.previewUrl
        @displayResult = false
        @currentTrack = data
        @currentTrack.releaseYear = data.releaseDate.split('-')[0]
        console.log(data.artistName, data.trackName)
        @audio.play()
        App.gameChannel.send event: 'play'
    displayResultCard: ->
      return if @displayResult
      @displayResult = true
      App.gameChannel.send event: 'pause'
      setTimeout @playNextSong, 5000
    buzzed: (data) ->
      @buzzingPlayer = data.player
      @audio.pause()
    answered: (data) ->
      @buzzingPlayer = null
      Vue.set @players, @players.findIndex((p) -> p.id is data.player.id), data.player
      @players.sort((p1, p2) => p2.score - p1.score)
      @currentTrack.artistFound ||= data.artist_found
      @currentTrack.trackFound ||= data.track_found
      @displayResultCard() if @currentTrack.artistFound && @currentTrack.trackFound
      @audio.play()
    draw: ->
      return if @audio.currentTime is @audio.duration
      α = Math.round(@audio.currentTime / @audio.duration * 360)
      r = (α * Math.PI / 180)
      x = Math.sin(r) * 125
      y = Math.cos(r) * -125
      mid = if α > 180 then 1 else 0
      @anim = "M 0 0 v -125 A 125 125 1 #{mid} 1 #{x} #{y} z" unless isNaN(x)
      setTimeout (=> @draw()), 500
