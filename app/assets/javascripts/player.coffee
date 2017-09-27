document.querySelector('#start-game')?.onsubmit = (e) ->
  fetch(this.action, method: 'PUT')
  false

document.querySelector('.buzzer')?.onclick = ->
  App.gameChannel.send event: 'buzz', player_id: player_id
  document.querySelector('.answer').classList.remove('d-none')
  document.querySelector('.buzzer').classList.add('d-none')

document.querySelector('.answer')?.onsubmit = ->
  fetch this.action,
    method: 'POST'
    body: JSON.stringify({value: this.querySelector('input[type=text]').value})
    headers: {'Content-Type': 'application/json'}
    credentials: 'same-origin'
  document.querySelector('.buzzer').classList.remove('d-none')
  document.querySelector('.answer').classList.add('d-none')
  document.querySelector('.buzzer').setAttribute('disabled', 'disabled')
  setTimeout (-> document.querySelector('.buzzer').removeAttribute('disabled')), 2000
  false
