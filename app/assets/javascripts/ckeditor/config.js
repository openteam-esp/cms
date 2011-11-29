/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.editorConfig = function( config )
{
  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  // config.uiColor = '#AADC6E';

  config.fillEmptyBlocks = false;

  config.disableNativeSpellChecker = false;

  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/el_finder";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/el_finder";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/el_finder";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/el_finder";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/el_finder";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/el_finder";

  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/el_finder";

  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token = jQuery('meta[name=csrf-token]').attr('content'),
        csrf_param = jQuery('meta[name=csrf-param]').attr('content'),
        params = new Object();

    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }

    return params;
  };

  /* Extra plugins */
  // works only with en, ru, uk locales
  //config.extraPlugins = "embed,attachment";

  /* Toolbars */
  config.toolbar = 'Full'; // Используются всё, что возможно, остальное впринципе отключено

  config.toolbar_Full = [
    ['Source'],
    ['Cut','Copy','Paste','PasteText','PasteFromWord'],
    ['Undo','Redo','-','Find','Replace','-','SelectAll','RemoveFormat'],
    ['Esp_link','Esp_unlink','Esp_anchor'],
    ['Esp_image', 'Esp_attachment', 'Esp_video', 'Esp_audio', 'Table'],
    '/',
    ['Format'],
    ['Bold','Italic','Underline','Strike','-','Subscript','Superscript'],
    ['JustifyLeft','JustifyCenter','JustifyRight'],
    ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
    ['Maximize', 'Esp_ShowBlocks']
  ];

};

CKEDITOR.on('instanceReady', function(ev) {

  ev.editor.dataProcessor.writer.indentationChars = "  ";

  var tags = new Array('p','h1','h2','h3','h4','h5','h6', 'td', 'li');
  for (var tag in tags) {
    ev.editor.dataProcessor.writer.setRules(tags[tag], {
      indent : false,
      breakBeforeOpen : false,
      breakAfterOpen : false,
      breakBeforeClose : false,
      breakAfterClose : true
    });
  };

  var html5 = new Array('audio','video', 'source');
  for (var tag in html5) {
  ev.editor.dataProcessor.writer.setRules(html5[tag], {
      indent : true,
      breakBeforeOpen : true,
      breakAfterOpen : true,
      breakBeforeClose : true,
      breakAfterClose : true
    });
  };

  ev.editor.dataProcessor.htmlFilter.addRules({
    elements:
    {
      $: function (element) {
        // Output dimensions of images as width and height
        if (element.name == 'img') {
          var style = element.attributes.style;
          if (style) {
            // Get the width from the style.
            var match = /(?:^|\s)width\s*:\s*(\d+)px/i.exec(style),
                width = match && match[1];
            if (width) {
              element.attributes.style = element.attributes.style.replace(/(?:^|\s)width\s*:\s*(\d+)px;?/i, '');
              element.attributes.width = width;
            }
            // Get the height from the style.
            match = /(?:^|\s)height\s*:\s*(\d+)px/i.exec(style);
            var height = match && match[1];
            if (height) {
              element.attributes.style = element.attributes.style.replace(/(?:^|\s)height\s*:\s*(\d+)px;?/i, '');
              element.attributes.height = height;
            }
            // Get the float from the style.
            match = /(?:^|\s)float\s*:\s*([a-z]+);/i.exec(style);
            var float = match && match[1];
            if (float) {
              element.attributes.class = "float_" + float;
            }
          }
        }
        if (!element.attributes.style)
          delete element.attributes.style;
        return element;
      }
    }
  });

});
