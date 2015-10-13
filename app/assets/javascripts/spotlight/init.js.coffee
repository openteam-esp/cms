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
    reload_ckeditors()
    return

  $('.spotlight_items').bind 'nested:fieldRemoved', (e) ->
    reload_ckeditors()
    reorder_positions()
    return

  reload_ckeditors = ->
    $.each CKEDITOR.instances, (index, instance) ->
      instance.destroy()
      return
    CKEDITOR.replaceAll()
    return

  reorder_positions = ->
    $('.spotlight_items .fields:visible .spotlight_position').each (index, item) ->
      $(this).val(index + 1)
      return

    return

  $(document).on 'click', '.spotlight_items .item .handler_up', (e) ->
    block = $(this).closest('.fields')
    target = block.prevAll('.fields:visible').first()
    console.log target
    return unless target.length
    block.swap
      target: target
      speed: 500
      callback: ->
        $.each CKEDITOR.instances, (index, instance) ->
          instance.destroy()
          return
        block.removeAttr('style').insertBefore(target.removeAttr('style'))
        CKEDITOR.replaceAll()
        reorder_positions()
        return
    return

  $(document).on 'click', '.spotlight_items .item .handler_down', (e) ->
    block = $(this).closest('.fields')
    target = block.nextAll('.fields:visible').first()
    return unless target.length
    block.swap
      target: target
      speed: 500
      callback: ->
        $.each CKEDITOR.instances, (index, instance) ->
          instance.destroy()
          return
        block.removeAttr('style').insertAfter(target.removeAttr('style'))
        CKEDITOR.replaceAll()
        reorder_positions()
        return
    return

  return

$ ->

  init_spotlight() if $('.spotlight_items').length

  return
