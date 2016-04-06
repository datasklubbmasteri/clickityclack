guess = 0
cap = 0
cur = 0

update = (type) ->
  verb = 'GET'
  route = 'get'
  document.getElementById('increment').disabled = cur >= cap
  document.getElementById('decrement').disabled = cur <= 0
  guess = cur
  if type != 0
    verb = 'POST'
    if type > 0
      route = 'increment'
      guess++
      document.getElementById('count').textContent = cur + 1
      document.getElementById('decrement').disabled = false
      document.getElementById('increment').disabled = cur + 1 >= cap
    else
      route = 'decrement'
      guess--
      document.getElementById('count').textContent = cur - 1
      document.getElementById('increment').disabled = false
      document.getElementById('decrement').disabled = cur - 1 <= 0
  xmlhttp = new XMLHttpRequest

  xmlhttp.onreadystatechange = ->
    if xmlhttp.readyState == 4 and xmlhttp.status == 200
      response = JSON.parse(xmlhttp.responseText)
      # console.log response.count
      cap = parseInt(response.cap)
      cur = parseInt(response.count)
      if guess != response.count
        if verb != 'GET'
          document.getElementById('count').textContent = response.count
        else
          guess = response.count
      else
        document.getElementById('count').textContent = response.count
    return

  xmlhttp.open verb, eventid + '/' + route
  xmlhttp.setRequestHeader 'Content-Type', 'application/json;charset=UTF-8'
  xmlhttp.send()
  return

refresh = ->
  setTimeout (->
    update 0
    refresh()
    return
  ), 1000
  return

document.addEventListener 'DOMContentLoaded', ->
  # No iOS app exists yet.
  # userAgent = window.navigator.userAgent
  # if userAgent.match(/iPad/i) or userAgent.match(/iPhone/i)
  #   if confirm('Would you like to open this event in the iOS app?')
  #     document.location.href = 'clickityclack://' + eventid

  document.getElementById('increment').addEventListener 'click', (event) ->
    update 1
    rippleEffect event.target
    updateHistory event.target

  document.getElementById('label').addEventListener 'click', ->
    update 0

  document.getElementById('decrement').addEventListener 'click', (event) ->
    update -1
    rippleEffect event.target
    updateHistory event.target

  document.addEventListener 'keydown', (e) ->
    if e.which == 38 && !document.getElementById('increment').disabled
      update 1
      rippleEffect document.getElementById('increment')
    else if e.which == 40 && !document.getElementById('decrement').disabled
      update -1
      rippleEffect document.getElementById('decrement')

  refresh()
  update 0

updateHistory = (element) ->
  current = parseInt document.getElementById('history').innerHTML
  console.log current
  if element.id == 'increment'
    ++current
  else
    --current
  if current > 0
    current = "+" + current
  document.getElementById('history').innerHTML = current
  window.setTimeout (->
    document.getElementById('history').innerHTML = 0
    return
  ), 3000
  console.log current
  # n = document.createElement 'span'


anim = (element) ->
  entry = document.createElement 'entry'
  entry.className = element.id
  console.log entry
  symbol = if element.id == 'increment' then '+' else '-'
  entry.innerHTML = symbol
  document.getElementById('history').appendChild entry
  # div.style
  # elemtn.append

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
