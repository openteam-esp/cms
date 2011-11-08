/*
 * @file Esp_video plugin for CKEditor
 * Copyright (C) 2011 Alfonso Martínez de Lizarrondo
 *
 * == BEGIN LICENSE ==
 *
 * Licensed under the terms of any of the following licenses at your
 * choice:
 *
 *  - GNU General Public License Version 2 or later (the "GPL")
 *    http://www.gnu.org/licenses/gpl.html
 *
 *  - GNU Lesser General Public License Version 2.1 or later (the "LGPL")
 *    http://www.gnu.org/licenses/lgpl.html
 *
 *  - Mozilla Public License Version 1.1 or later (the "MPL")
 *    http://www.mozilla.org/MPL/MPL-1.1.html
 *
 * == END LICENSE ==
 *
 */

CKEDITOR.plugins.add( 'esp_video',
{
  // Translations, available at the end of this file, without extra requests
  lang: ['en', 'ru', 'uk'],
  init : function( editor )
  {
    var lang = editor.lang.esp_video;

    // Check for CKEditor 3.5
    if (typeof editor.element.data == 'undefined')
    {
      alert('The "video" plugin requires CKEditor 3.5 or newer');
      return;
    }

    CKEDITOR.dialog.add( 'esp_video', this.path + 'dialogs/esp_video.js' );

    editor.addCommand( 'esp_video', new CKEDITOR.dialogCommand( 'esp_video' ) );
    editor.ui.addButton( 'Esp_video',
      {
        label : lang.toolbar,
        command : 'esp_video',
        icon : this.path + 'images/esp_video.png'
      } );

    editor.addCss(
      'img.cke_video' +
      '{' +
        'background-image: url(' + CKEDITOR.getUrl( this.path + 'images/placeholder.png' ) + ');' +
        'background-position: center center;' +
        'background-repeat: no-repeat;' +
        'background-color:gray;'+
        'border: 1px solid #a9a9a9;' +
        'width: 80px;' +
        'height: 80px;' +
      '}');


      // If the "menu" plugin is loaded, register the menu items.
      if ( editor.addMenuItems )
      {
        editor.addMenuItems(
          {
            video :
            {
              label : lang.properties,
              command : 'video',
              group : 'flash'
            }
          });
      }

      editor.on( 'doubleclick', function( evt )
        {
          var element = evt.data.element;

          if ( element.is( 'img' ) && element.data( 'cke-real-element-type' ) == 'video' )
            evt.data.dialog = 'video';
        });

      // If the "contextmenu" plugin is loaded, register the listeners.
      if ( editor.contextMenu )
      {
        editor.contextMenu.addListener( function( element, selection )
          {
            if ( element && element.is( 'img' ) && !element.isReadOnly()
                && element.data( 'cke-real-element-type' ) == 'video' )
              return { video : CKEDITOR.TRISTATE_OFF };
          });
      }

    // Add special handling for these items
    CKEDITOR.dtd.$empty['cke:source']=1;
    CKEDITOR.dtd.$empty['source']=1;

    editor.lang.fakeobjects.video = lang.fakeObject;


  }, //Init

  afterInit: function( editor )
  {

  var dataProcessor = editor.dataProcessor,
    htmlFilter = dataProcessor && dataProcessor.htmlFilter,
    dataFilter = dataProcessor && dataProcessor.dataFilter;
        var handler = editor.plugins.googleMapsHandler;

  // dataFilter : conversion from html input to internal data
  dataFilter.addRules(
    {

    elements : {
      $ : function( realElement )
      {
          if ( realElement.name == 'video' )
          {
            realElement.name = 'cke:video';
            var fakeElement = editor.createFakeParserElement( realElement, 'cke_video', 'video', false ),
              fakeStyle = fakeElement.attributes.style || '';

            var width = realElement.attributes.width,
              height = realElement.attributes.height,
              poster = realElement.attributes.poster;

            if ( typeof width != 'undefined' )
              fakeStyle = fakeElement.attributes.style = fakeStyle + 'width:' + CKEDITOR.tools.cssLength( width ) + ';';

            if ( typeof height != 'undefined' )
              fakeStyle = fakeElement.attributes.style = fakeStyle + 'height:' + CKEDITOR.tools.cssLength( height ) + ';';

            if ( poster )
              fakeStyle = fakeElement.attributes.style = fakeStyle + 'background-image:url(' + poster + ');';

            return fakeElement;
          }
      }
    }

    }
  );

  // htmlFilter : conversion from internal data to html output.
  htmlFilter.addRules(
    {
      elements :
      {
        $ : function( element )
        {
          if ( element.name == 'img' )
          {

            var number = element.attributes.mapnumber;
            if (number)
            {
              var scriptNode,
                handler = editor.plugins.googleMapsHandler,
                oMap = handler.getMap( number ) ;

              if (oMap && oMap.generatedType>1)
              {
                handler.CreatedMapsNames.push( oMap.number ) ;
                // Inject the <script> for this map
                scriptNode = new CKEDITOR.htmlParser.cdata( oMap.BuildScript() );
                element.parent.children.push( scriptNode );
              }
              delete element.attributes.mapnumber;
            }
          }

          return element;
        }
      }
    });



  }
} );

