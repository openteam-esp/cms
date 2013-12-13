function blue_pages_autocomplete() {
  var list = $('.blue_pages_categories ul li');
  var source = [];
  list.each(function(index, item) {
    source.push({id: $(item).data('id'), value: $(item).text(), label: $(item).text()});
    if ($('#part_blue_pages_category_id').val() && $('#part_blue_pages_category_id').val() == $(item).data('id')) {
      $('#part_blue_pages_category').val($(item).text());
    }
  });
  $('#part_blue_pages_category').autocomplete({
    minLength: 2,
    source: source,
    select: function(event, ui) {
      $('#part_blue_pages_category_id').val(ui.item.id)
    }
  });
};

$(function() {
  if ($.fn.autocomplete && $('.blue_pages_categories ul li').length) {
    blue_pages_autocomplete();
  }
});
