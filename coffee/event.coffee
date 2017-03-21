socket = io().connect()

socket.on 'connect', ->
  socket.emit 'join', event: eventid
  document.getElementById('increment').disabled = count >= cap
  document.getElementById('decrement').disabled = count <= 0

socket.on 'disconnect', ->
  document.getElementById('increment').disabled = true
  document.getElementById('decrement').disabled = true

socket.on 'update', (data) ->
  count = data.count
  document.getElementById('count').textContent = count
  document.getElementById('increment').disabled = count >= cap
  document.getElementById('decrement').disabled = count <= 0

increment = ->
    socket.emit('increment', event: eventid)
    rippleEffect document.getElementById('increment')

decrement = ->
    socket.emit('decrement', event: eventid)
    rippleEffect document.getElementById('decrement')

document.addEventListener 'DOMContentLoaded', ->
  # No iOS app exists yet.
  # userAgent = window.navigator.userAgent
  # if userAgent.match(/iPad/i) or userAgent.match(/iPhone/i)
  #   if confirm('Would you like to open this event in the iOS app?')
  #     document.location.href = 'clickityclack://' + eventid

  document.getElementById('increment').addEventListener 'click', (event) ->
    increment()

  document.getElementById('decrement').addEventListener 'click', (event) ->
    decrement()

  document.addEventListener 'keydown', (e) ->
    if e.which == 38 && !document.getElementById('increment').disabled
      increment()
    else if e.which == 40 && !document.getElementById('decrement').disabled
      decrement()

rippleEffect = (element) ->
  div = document.createElement('div')
  div.className = 'ripple-effect'
  div.style.top = if element.id == 'decrement' then '0%' else '100%'
  div.style.background = element.dataset.rippleColor
  element.appendChild div
  window.setTimeout (->
    element.removeChild div
    return
  ), 1000
  return
