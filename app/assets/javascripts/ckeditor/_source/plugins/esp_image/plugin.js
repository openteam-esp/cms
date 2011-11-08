/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.plugins.add( 'esp_image',
{
  lang: ['en', 'ru', 'uk'],
  init : function( editor )
  {
    var pluginName = 'esp_image';

    // Register the dialog.
    CKEDITOR.dialog.add( pluginName, this.path + 'dialogs/esp_image.js' );

    // Register the command.
    editor.addCommand( pluginName, new CKEDITOR.dialogCommand( pluginName ) );

    // Register the toolbar button.
    editor.ui.addButton( 'Esp_image',
      {
        label : editor.lang.esp_image.image,
        command : pluginName,
        icon: this.path + "images/esp_image.png"
      });

    editor.on( 'doubleclick', function( evt )
      {
        var element = evt.data.element;

        if ( element.is( 'img' ) && !element.data( 'cke-realelement' ) && !element.isReadOnly() )
          evt.data.dialog = 'esp_image';
      });

    // If the "menu" plugin is loaded, register the menu items.
    if ( editor.addMenuItems )
    {
      editor.addMenuItems(
        {
          esp_image :
          {
            label : editor.lang.esp_image.menu,
            command : 'esp_image',
            group : 'esp_image'
          }
        });
    }

    // If the "contextmenu" plugin is loaded, register the listeners.
    if ( editor.contextMenu )
    {
      editor.contextMenu.addListener( function( element, selection )
        {
          if ( !element || !element.is( 'img' ) || element.data( 'cke-realelement' ) || element.isReadOnly() )
            return null;

          return { esp_image : CKEDITOR.TRISTATE_OFF };
        });
    }
  }
} );

/**
 * Whether to remove links when emptying the link URL field in the image dialog.
 * @type Boolean
 * @default true
 * @example
 * config.image_removeLinkByEmptyURL = false;
 */
CKEDITOR.config.esp_image_removeLinkByEmptyURL = true;

/**
 *  Padding text to set off the image in preview area.
 * @name CKEDITOR.config.image_previewText
 * @type String
 * @default "Lorem ipsum dolor..." placehoder text.
 * @example
 * config.image_previewText = CKEDITOR.tools.repeat( '___ ', 100 );
 */

