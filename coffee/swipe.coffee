swipeController = new Hammer(document)
swipeController.get('swipe').set direction: Hammer.DIRECTION_VERTICAL
swipeController.on 'swipeup', (ev) ->
  document.getElementById('increment').click()
  return
swipeController.on 'swipedown', (ev) ->
  document.getElementById('decrement').click()
  return
