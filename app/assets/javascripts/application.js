/*
 * This is a manifest file that'll be compiled into including all the files listed below.
 * Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
 * be included in the compiled file accessible from http://example.com/assets/application.js
 * It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
 * the compiled file.
 *
 *= require jquery.min.js
 *= require jquery-ui.min.js
 *= require jquery.ui.datepicker-ru.js
 *= require jquery_ujs.js
 *= require jquery_nested_form.js
 *= require treeview/jquery.cookie.js
 *= require treeview/jquery.treeview.js
 *= require treeview/jquery.treeview.edit.js
 *= require treeview/jquery.treeview.async.js
 *= require jquery-colorbox.js
 */

function init_colorbox() {
  $('.js-colorbox').colorbox({
    maxWidth: '90%',
    maxHeight: '90%',
    current: '{current} / {total}',
    previous: 'назад',
    next: 'вперед',
    close: 'закрыть'
  });
};

function init_tree() {
  if ($.fn.treeview && $('.nodes_tree').length) {
    $('.nodes_tree').treeview({
      url: '/manage/treeview',
      persist: 'location'
    });
  };
};

function init_date_picker() {
  if ($.fn.datepicker) {
    $('.formtastic .inputs .date_picker').datepicker({
      changeMonth: true,
      changeYear: true,
      showOn: "button",
      showOtherMonths: true
    });
  };
};

function init_tabs() {
  if ($.fn.tabs) {
    $("#tabs").tabs();
  };
};

function serializeBlock(parent_block) {
  var ids = $.makeArray(
    $(".sortable li", parent_block).map(function() {
      return $(this).data("id");
    }));
  var csrf_token = $("head meta[name='csrf-token']").attr("content");
  return {
    "ids": ids,
    "authenticity_token" : csrf_token
  };
};

function init_sortable() {
  $(".sort_link").click(function() {
    var it_off = $(this).hasClass("off"),
        url = $(this).attr("href"),
        parent_block = $(this).parent().parent();
    if (it_off) {
      $(this).removeClass("off").addClass("on").addClass("invert");
      $(".sortable span", parent_block).removeClass("hidden").addClass("inline-block");
      $(".sortable", parent_block).sortable({
        axis: "y",
        handle: "span",
        update: function() {
          var block = this;
          $.ajax({
            url: url,
            type: "post",
            data: serializeBlock(parent_block),
            success: function(data, textStatus, jqXHR) {
              $(block).effect("highlight");
            },
            error: function(jqXHR, textStatus, errorThrown) {
              $("<div />")
                .attr("id", "ajax_error")
                .appendTo("body")
                .hide()
                .html(jqXHR.responseText);
              $("#ajax_error meta").remove();
              $("#ajax_error style").remove();
              $("#ajax_error").dialog({
                title: errorThrown,
                width: "70%",
                height: 500,
                modal: true,
                resizable: false
              });
            }
          });
        }
      });
    } else {
      $(".sortable span", parent_block).removeClass("inline-block").addClass("hidden");
      $(this).removeClass("on").addClass("off").removeClass("invert");
    };
    return false;
  });
};

function init_spotlight() {
  /* manipulate on form */
  if ($('.spotlight_items').length) {
    $('.spotlight_items').bind('nested:fieldAdded', function(e) {
      max_position = 0
      positions = $('.fields:visible .spotlight_position', $(e.target).closest('.spotlight_items')).map(function() {
        return parseInt($(this).val());
      }).get();
      positions = positions.filter(Number);
      if (positions.length) {
        max_position = Math.max.apply(null, positions);
      }
      $('.spotlight_position', e.target).val(max_position + 1);
    })
    $('.spotlight_items').bind('nested:fieldRemoved', function(e) {
      $('.fields:visible .spotlight_position', $(e.target).closest('.spotlight_items')).each(function(index, item) {
        $(this).val(index + 1);
      });
    });
    $('.spotlight_items').sortable({
      axis: 'y',
      update: function(e, ui) {
        $('.fields:visible .spotlight_position', e.target).each(function(index, item) {
          $(this).val(index + 1);
        });
      }
    });
  }

  /* preview on part show */
  if ($('.js-spotlight-preview').length) {
    $('.js-spotlight-preview').click(function() {
      collection = $('.spotlight_part .spotlight_url:visible');
      collection.each(function(index, item) {
        if ($(this).is('a')) {
          var context = $(this).closest('li');
          var elem = $(this);
          var data_url = elem.attr('href');
          var preview_block = $('.preview_spotlight_item', context);
        }
        if ($(this).is('input')) {
          var context = $(this).closest('ul');
          var elem = $(this);
          var data_url = elem.val();
          var preview_block = $('.preview_spotlight_item', context);
        }
        console.log(this)

        $.ajax({
          url: '/manage/spotlight',
          data: { url: data_url },
          type: 'GET',
          context: context,
          dataType: 'json',
          beforeSend: function(jqXHR, settings) {
            $(preview_block).html('');
          },
          complete: function(jqXHR, textStatus) {
            $(preview_block).html('').slideUp(function() {
              if (textStatus == 'success') {
                response = jqXHR.responseText;
                json = JSON.parse(response);
                var code_class = '';
                if (json.code == 200 || json.code == 302) {
                  code_class = 'success';
                } else {
                  code_class = 'error';
                }
                $('<p>', { class: code_class, html: '<b>code</b>: ' + json.code }).appendTo(preview_block);
                if (typeof json.body === 'object') {
                  $('<p>', { class: code_class, html: '<b>type</b>: ' + json.body.type }).appendTo(preview_block);
                  $('<p>', { class: code_class, html: '<b>slug</b>: ' + json.body.slug }).appendTo(preview_block);
                  $('<p>', { class: code_class, html: '<b>title</b>: ' + json.body.title }).appendTo(preview_block);
                  $('<p>', { class: code_class, html: '<b>annotation</b>: ' + json.body.annotation }).appendTo(preview_block);
                  if (json.body.images.length) {

                    var content = json.body.images.map(function(e) {
                      return '<a href="' + e.url + '" target="_blank" class="js-colorbox" rel="' + json.body.slug + '">' +
                        '<img width="100" height="100" src="' + e.url.replace(/\/\d+-\d+\//, '/100-100!n/') + '" />' +
                        '</a>';
                    });
                    $('<p>', { class: code_class, html: '<b>images</b>: <br />' + content.join(' ') }).appendTo(preview_block);
                  }
                } else {
                  $('<p>', { class: code_class, html: '<b>text</b>: ' + json.body }).appendTo(preview_block);
                }
              }
              if (textStatus == 'error') {
                $('<p>', { class: 'error', text: 'code: ' + jqXHR.status }).appendTo(preview_block);
                $('<p>', { class: 'error', text: 'text: ' + jqXHR.statusText }).appendTo(preview_block);
              }
              preview_block.slideDown();
              init_colorbox();
            });
          }
        });
      });

      return false;
    });
  }
}

function toggle_position_fields(field) {
  if ($(field).is(":checked")) {
    $("#page_navigation_group").removeAttr("disabled");
    $("#page_navigation_group").closest("li").removeClass("disabled");
    $("#page_navigation_position_param").removeAttr("disabled");
    $("#page_navigation_position_param").closest("li").removeClass("disabled");
  } else {
    $("#page_navigation_group").attr("disabled", "disabled");
    $("#page_navigation_group").closest("li").addClass("disabled");
    $("#page_navigation_position_param").attr("disabled", "disabled");
    $("#page_navigation_position_param").closest("li").addClass("disabled");
  };
};

function manipulate_position_fields() {
  var field = $("#page_in_navigation");
  toggle_position_fields(field);
  $(field).click(function() {
    toggle_position_fields(field);
  });
};

function sync_changes_in_titles(title_id, navigation_title_id) {
  var title = $(title_id),
      title_val = title.val(),
      navigation_title = $(navigation_title_id),
      navigation_title_val = navigation_title.val();
  if (title.length && navigation_title.length) {
    if (title_val == navigation_title_val) {
      title.blur(function() {
        if ($(this).val() != navigation_title_val) {
          navigation_title.val($(this).val());
        };
      });
    };
  };
};

function manipulate_titles() {
  sync_changes_in_titles("#page_title", "#page_navigation_title");
  $("#page_title").focus(function() {
    $(this).unbind('blur');
    sync_changes_in_titles("#page_title", "#page_navigation_title");
  });
};

function choose_picture(){
  $('.choose_picture').live('click', function() {
    var link = $(this);
    var origin_id = link.closest('.fields').find('.picture_url').attr('id');
    var input = $('#'+origin_id);

    var dialog = link.create_or_return_dialog('elfinder_picture_dialog');

    dialog.attr('id_data', origin_id);

    dialog.load_iframe();

    input.change(function(){
      var url = input.val();
      var type = url.match(/.(\w+)$/)[1];
      var name = url.split('/').slice(-1)[0];
      var presentation = input.closest('.fields').find('.presentation');
      var description = input.closest('.fields').find('.description');
      var link_to_file = $('.link_to_file', description);
      if (type.match(/jpeg|jpg|png|bmp|tiff/i)) {
        var array_url = url.split('/');
        array_url.splice(-2, 1);
        var resized_url = array_url.slice(0, array_url.length-1);
        resized_url.push('200-200');
        resized_url.push(array_url.slice(-1)[0]);
        presentation.css('width', '200').html('<img src='+resized_url.join('/')+' width="200px" alt='+name+'/>');
      } else {
        presentation.css('width', '200').html('<a href='+url+'>'+name+'</a>');
      };
      if (link_to_file.length) {
        link_to_file.attr('href', url);
        link_to_file.text(name);
      } else {
        description.prepend('<a class="link_to_file" href="' + url + '">' + name + '</a>');
      };

      input.unbind('change');
    });

    return false;
  });
};

$(function() {
  init_tree();
  init_date_picker();
  init_tabs();
  init_sortable();
  init_spotlight();
  manipulate_position_fields();
  manipulate_titles();
  choose_picture();
});
