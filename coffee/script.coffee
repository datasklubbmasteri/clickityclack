document.addEventListener 'DOMContentLoaded', ->
  numfield = document.getElementById('numberfield')
  namefield = document.getElementById('namefield')
  pubfield = document.getElementById('publicfield')
  namefield.addEventListener 'keydown', (e) ->
    if e.which == 13 and !numfield.classList.contains('invalid') and !namefield.classList.contains('invalid')
      xmlhttp = new XMLHttpRequest

      xmlhttp.onreadystatechange = ->
        if xmlhttp.readyState == 4 and xmlhttp.status == 200
          response = JSON.parse(xmlhttp.responseText)
          document.location.href = '../' + response._id

      xmlhttp.open 'POST', 'create'
      xmlhttp.setRequestHeader 'Content-Type', 'application/json;charset=UTF-8'
      xmlhttp.send JSON.stringify(
        name: namefield.value
        cap: numfield.value
        public: pubfield.checked)

  namefield.addEventListener 'input', (e) ->
    if namefield.value == ''
      if !namefield.classList.contains('invalid')
        namefield.classList.add 'invalid'
    else if namefield.classList.contains('invalid')
      namefield.classList.remove 'invalid'

  numfield.addEventListener 'input', (e) ->
    if numfield.value != '' and isNaN(numfield.value)
      if !numfield.classList.contains('invalid')
        numfield.classList.add 'invalid'
    else if numfield.classList.contains('invalid')
      numfield.classList.remove 'invalid'
