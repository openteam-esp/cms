/*
 * This is a manifest file that'll be compiled into including all the files listed below.
 * Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
 * be included in the compiled file accessible from http://example.com/assets/application.js
 * It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
 * the compiled file.
 *
 * = require jquery.min.js
 * = require jquery-ui.min.js
 * = require jquery.ui.datepicker-ru.js
 * = require jquery_ujs.js
 * = require jquery_nested_form.js
 * = require ckeditor/init
 * = require info_plugin
 * = require treeview/jquery.cookie.js
 * = require treeview/jquery.treeview.js
 * = require treeview/jquery.treeview.edit.js
 * = require treeview/jquery.treeview.async.js
 * = require jquery-colorbox.js
 * = require spotlight
 * = require sortable
 * = require common_autocomplete
 */

function init_colorbox() {
  $('.js-colorbox').colorbox({
    maxWidth: '90%',
    maxHeight: '90%',
    returnFocus: false,
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
  init_colorbox();
  init_tree();
  init_date_picker();
  init_tabs();
  init_sortable();
  manipulate_position_fields();
  manipulate_titles();
  choose_picture();
  init_common_autocomplete();
});
