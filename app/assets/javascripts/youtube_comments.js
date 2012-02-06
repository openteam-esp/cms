$(function() {
  $('ul.pagination li a').live('click', function() {
    url = $(this).attr('href');

    $.ajax(url, {
      success: function(data, textStatus, jqXHR) {
        $('div.comments').html(data);
      }
    });

    return false;
  });
});
