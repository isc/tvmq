document.querySelector('#start-game')?.onsubmit = (e) ->
  fetch(this.action, method: 'PUT')
  false

document.querySelector('.buzzer')?.onclick = ->
  App.gameChannel.send event: 'buzz', player_id: player_id
  document.querySelector('.answer').classList.remove('d-none')
  document.querySelector('.buzzer').classList.add('d-none')

document.querySelector('.answer')?.onsubmit = ->
  fetch(this.action, method: 'POST', body: {value: this.querySelector('input[type=text]').value})
  false
