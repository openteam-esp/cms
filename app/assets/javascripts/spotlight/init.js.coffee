@init_spotlight = ->

  reload_ckeditors = ->
    $.each CKEDITOR.instances, (index, instance) ->
      instance.destroy()
      return
    CKEDITOR.replaceAll()
    return

  reorder_positions = ->
    $('.spotlight_items .fields:visible .position').each (index, item) ->
      $(this).val(index + 1)
      return
    return

  switch_dependent_fields_for = (kind_field) ->
    switch $(kind_field).val()
      when 'news'
        $('.annotation', kind_field.closest('.item')).show()
        $('.since', kind_field.closest('.item')).show()
        $('.starts_on', kind_field.closest('.item')).hide()
        $('.ends_on', kind_field.closest('.item')).hide()
      when 'event'
        $('.annotation', kind_field.closest('.item')).show()
        $('.since', kind_field.closest('.item')).hide()
        $('.starts_on', kind_field.closest('.item')).show()
        $('.ends_on', kind_field.closest('.item')).show()
      when 'photo', 'video'
        $('.annotation', kind_field.closest('.item')).hide()
        $('.since', kind_field.closest('.item')).show()
        $('.starts_on', kind_field.closest('.item')).hide()
        $('.ends_on', kind_field.closest('.item')).hide()
      when 'other'
        $('.annotation', kind_field.closest('.item')).show()
        $('.since', kind_field.closest('.item')).hide()
        $('.starts_on', kind_field.closest('.item')).hide()
        $('.ends_on', kind_field.closest('.item')).hide()
    $(kind_field).change ->
      switch_dependent_fields_for(this)
      return
    return

  $('.spotlight_items .item').each (index, item) ->
    kind_field = $('.spotlight_kind', item)
    switch_dependent_fields_for(kind_field)
    return

  $('.spotlight_items').bind 'nested:fieldAdded', (e) ->
    max_position = 0
    positions = $('.fields:visible .position', $(e.target).closest('.spotlight_items')).map ->
      parseInt($(this).val())
    .get()
    positions = positions.filter(Number)
    if positions.length
      max_position = Math.max.apply(null, positions)
    $('.position', e.target).val(max_position + 1)
    reload_ckeditors()
    switch_dependent_fields_for($('.spotlight_kind', e.target))
    return

  $('.spotlight_items').bind 'nested:fieldRemoved', (e) ->
    reload_ckeditors()
    reorder_positions()
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
