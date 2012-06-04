function sort_pictures_handler() {
  $('.pictures').sortable({
    stop: function() {
      $('.picture_position').each(function(index) {
        $(this).val(index + 1);
      });
    }
  });

  $('.pictures').disableSelection();
}

$(function() {
  sort_pictures_handler();
});


