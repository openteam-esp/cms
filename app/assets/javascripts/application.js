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
 *= require nested_form.js
 *= require treeview/jquery.cookie.js
 *= require treeview/jquery.treeview.js
 *= require treeview/jquery.treeview.edit.js
 *= require treeview/jquery.treeview.async.js
 */

var CKEDITOR_BASEPATH = '/assets/ckeditor/';

function init_tree() {
  if ($.fn.treeview) {
    $('.nodes_tree').treeview({
      url: '/treeview',
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

function init_sortable() {
  $(".sort_link").click(function() {
    var it_off = $(this).hasClass("off"),
        url = $(this).attr("href"),
        parent_block = $(this).parent().parent();
    if (it_off) {
      $(this).removeClass("off").addClass("on");
      $(".sortable span", parent_block).css("display", "inline-block");
      $(".sortable", parent_block).sortable({
        axis: "y",
        handle: "span",
        update: function() {
          var block = this;
          $.ajax({
            url: url,
            type: "post",
            data: serializeBlock(parent_block),
            beforeSend: function(jqXHR, settings) {
              show_ajax_indicator();
            },
            complete: function(jqXHR, textStatus) {
              hide_ajax_indicator();
            },
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
      $(".sortable span", parent_block).hide();
      $(this).removeClass("on").addClass("off");
    };
    return false;
  });
};

$(function() {
  init_tree();
  init_date_picker();
  init_tabs();
  //init_sortable();
});
