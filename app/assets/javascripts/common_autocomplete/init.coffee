@init_common_autocomplete = ->
  return unless $('.js-autocomplete').length

  autocomplete_field = $('.js-autocomplete')
  autocomplete_target  = $('.js-autocomplete-target')

  autocomplete_field.autocomplete
    source: autocomplete_field.data('source')
    select: (event, ui) ->
      autocomplete_target.val ui.item.id
