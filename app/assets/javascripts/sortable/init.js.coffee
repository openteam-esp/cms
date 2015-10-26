@init_nested_sortable = ->

  list = $('.js-sortable')

  reorder_positions = ->
    $('.fields:visible .js-sortable-position', list).each (index, item) ->
      $(this).val(index + 1)
      return
    return

  reorder_positions()

  list.sortable
    axis: 'y'
    handle: '.js-sortable-handler'
    update: (event, ui) ->
      reorder_positions()
      return

  list.bind 'nested:fieldAdded', (e) ->
    max_position = 0
    positions = $('.fields:visible .js-sortable-position', $(e.target).closest('.js-sortable')).map ->
      parseInt($(this).val())
    .get()
    positions = positions.filter(Number)
    if positions.length
      max_position = Math.max.apply(null, positions)
    $('.js-sortable-position', e.target).val(max_position + 1)
    return

  list.bind 'nested:fieldRemoved', (e) ->
    reorder_positions()
    return

  return

$ ->

  init_nested_sortable() if $('.js-sortable').length

  return
