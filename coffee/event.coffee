socket = io().connect()

guessCount = count
pendingUpdates = 0
incrementButton = undefined
decrementButton = undefined
countLabel = undefined

socket.on 'connect', ->
  socket.emit 'join', event: eventid
  updateButtonStates()

socket.on 'disconnect', ->
  incrementButton.disabled = true
  decrementButton.disabled = true

socket.on 'update', (payload) ->
  pendingUpdates = Math.max --pendingUpdates, 0
  if pendingUpdates <= 0
    guessCount = payload.count
    updateCountLabel payload.count
    updateButtonStates()

increment = ->
    socket.emit 'increment', event: eventid
    pendingUpdates++
    updateCountLabel ++guessCount
    updateButtonStates()
    rippleEffect incrementButton

decrement = ->
    socket.emit 'decrement', event: eventid
    pendingUpdates++
    updateCountLabel --guessCount
    updateButtonStates()
    rippleEffect decrementButton

document.addEventListener 'DOMContentLoaded', ->
  # No iOS app exists yet.
  # userAgent = window.navigator.userAgent
  # if userAgent.match(/iPad/i) or userAgent.match(/iPhone/i)
  #   if confirm('Would you like to open this event in the iOS app?')
  #     document.location.href = 'clickityclack://' + eventid

  incrementButton = document.getElementById 'increment'
  decrementButton = document.getElementById 'decrement'
  countLabel = document.getElementById 'count'

  incrementButton.addEventListener 'click', (event) ->
    increment()

  decrementButton.addEventListener 'click', (event) ->
    decrement()

  document.addEventListener 'keydown', (e) ->
    if e.which == 38 && !incrementButton.disabled
      increment()
    else if e.which == 40 && !decrementButton.disabled
      decrement()

updateCountLabel = (count) ->
  countLabel.textContent = count
  document.title = "#{name} | #{count}/#{cap}"

updateButtonStates = ->
  incrementButton.disabled = guessCount >= cap
  decrementButton.disabled = guessCount <= 0

rippleEffect = (element) ->
  div = document.createElement 'div'
  div.className = 'ripple-effect'
  div.style.top = if element.id == 'decrement' then '0%' else '100%'
  div.style.background = element.dataset.rippleColor
  element.appendChild div
  window.setTimeout (->
    element.removeChild div
    return
  ), 1000
  return
