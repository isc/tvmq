tv = location.pathname.match('/tv')
audio = null
currentTrack = null

App.gameChannel = App.cable.subscriptions.create { channel: "GameChannel" },
  received: (data) ->
    if data.event is 'new_player'
      newPlayer = document.createElement('div')
      newPlayer.className = "list-group-item d-flex justify-content-between align-items-center player-#{data.player.id}"
      newPlayer.innerText = data.player.name
      score = document.createElement('span')
      score.className = 'badge badge-primary badge-pill'
      score.innerText = data.player.score
      newPlayer.appendChild(score)
      document.querySelector('.list-group')?.appendChild(newPlayer)
    if data.event is 'game_start'
      document.querySelector('.lobby').classList.add('d-none')
      document.querySelector('.game').classList.remove('d-none')
      playNextSong() if tv
    if data.event is 'buzz'
      if window.player_id and player_id isnt data.player_id
        document.querySelector('.buzzer').setAttribute('disabled', 'disabled')
      else if tv
        document.querySelector(".player-#{data.player_id}").classList.add('list-group-item-warning')
        audio?.pause()
    if data.event is 'answer' and tv
      audio?.play()
      playerItem = document.querySelector(".player-#{data.player.id}")
      playerItem.classList.remove('list-group-item-warning')
      playerItem.querySelector('.badge').innerText = data.player.score
      playerItem.classList.add('list-group-item-success') if data.track_found || data.artist_found
      if data.artist_found && data.track_found
        displayResultCard(currentTrack)
      else
        document.querySelector('.artistName').innerText = currentTrack.artistName if data.artist_found
        document.querySelector('.trackName').innerText = currentTrack.trackName if data.track_found

loader = document.getElementById('loader')
border = document.getElementById('border')

draw = (audio) ->
  return if audio.currentTime is audio.duration
  α = Math.round(audio.currentTime / audio.duration * 360)
  r = (α * Math.PI / 180)
  x = Math.sin(r) * 125
  y = Math.cos(r) * - 125
  mid = if α > 180 then 1 else 0
  anim = "M 0 0 v -125 A 125 125 1 #{mid} 1 #{x} #{y} z"
  loader.setAttribute 'd', anim
  border.setAttribute 'd', anim
  setTimeout (-> draw(audio)), 100

playNextSong = ->
  fetch('/tracks').then((r) -> r.json()).then (data) ->
    currentTrack = data
    audio = new Audio(data.previewUrl)
    audio.addEventListener 'playing', ->
      document.querySelector('.result-card').classList.add('d-none')
      document.querySelector('.timer-card').classList.remove('d-none')
      draw(audio)
    audio.play()
    audio.addEventListener 'ended', -> displayResultCard(data)

displayResultCard = (data) ->
  document.querySelector('.result-card').classList.remove('d-none')
  document.querySelector('.timer-card').classList.add('d-none')
  document.querySelector('.result-card img').src = data.artworkUrl30.replace('30x30', '400x400')
  data.releaseYear = data.releaseDate.split('-')[0]
  for attribute in ['artistName', 'trackName', 'collectionName', 'releaseYear']
    document.querySelector(".#{attribute}").innerText = data[attribute]
  setTimeout(playNextSong, 10000)
