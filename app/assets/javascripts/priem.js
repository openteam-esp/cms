function priem_contexts_autocomplete() {
  var list = $('.priem_contexts ul li');
  var source = [];
  list.each(function(index, item) {
    source.push({id: $(item).data('context-id'), kind: $(item).data('context-kind'), value: $(item).text(), label: $(item).text()});
    if ($('#priem_context_id').val() && $('#priem_context_id').val() == $(item).data('context-id')) {
      $('#priem_context').val($(item).text());
    }
  });
  console.log(source);
  $('#priem_context').autocomplete({
    minLength: 2,
    source: source,
    select: function(event, ui) {
      $('#priem_context_id').val(ui.item.id)
      $('#priem_context_kind').val(ui.item.kind)
    }
  });
};

$(function() {
  if ($.fn.autocomplete && $('.priem_contexts ul li').length) {
    priem_contexts_autocomplete();
  }
});
