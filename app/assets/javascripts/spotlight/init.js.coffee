@init_spotlight = ->

  $('.spotlight_items').bind 'nested:fieldAdded', (e) ->
    max_position = 0
    positions = $('.fields:visible .spotlight_position', $(e.target).closest('.spotlight_items')).map ->
      parseInt($(this).val())
    .get()
    positions = positions.filter(Number)
    if positions.length
      max_position = Math.max.apply(null, positions)
    $('.spotlight_position', e.target).val(max_position + 1)
    return

  $('.spotlight_items').bind 'nested:fieldRemoved', (e) ->
    $('.fields:visible .spotlight_position', $(e.target).closest('.spotlight_items')).each (index, item) ->
      $(this).val(index + 1)
      return
    return

  $('.spotlight_items').sortable
    axis: 'y'
    update: (e, ui) ->
      $('.fields:visible .spotlight_position', e.target).each (index, item) ->
        $(this).val(index + 1)
        return
      return

  return

$ ->

  init_spotlight() if $('.spotlight_items').length

  return
