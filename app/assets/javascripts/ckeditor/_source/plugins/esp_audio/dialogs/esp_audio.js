CKEDITOR.dialog.add( 'esp_audio', function ( editor )
{
  var lang = editor.lang.esp_audio;

  function commitValue( audioNode, extraStyles )
  {
    var value=this.getValue();

    if ( !value && this.id=='id' )
      value = generateId();

    audioNode.setAttribute( this.id, value);

    if ( !value )
      return;
    switch( this.id )
    {
      case 'width':
        extraStyles.width = value + 'px';
        break;
      case 'height':
        extraStyles.height = value + 'px';
        break;
    }
  }

  function commitSrc( audioNode, extraStyles, audios )
  {
    var match = this.id.match(/(\w+)(\d)/),
      id = match[1],
      number = parseInt(match[2], 10);

    var audio = audios[number] || (audios[number]={});
    audio[id] = this.getValue();
  }

  function loadValue( audioNode )
  {
    if ( audioNode )
      this.setValue( audioNode.getAttribute( this.id ) );
    else
    {
      if ( this.id == 'id')
        this.setValue( generateId() );
    }
  }

  function loadSrc( audioNode, audios )
  {
    var match = this.id.match(/(\w+)(\d)/),
      id = match[1],
      number = parseInt(match[2], 10);

    var audio = audios[number];
    if (!audio)
      return;
    this.setValue( audio[ id ] );
  }

  function generateId()
  {
    var now = new Date();
    return 'audio' + now.getFullYear() + now.getMonth() + now.getDate() + now.getHours() + now.getMinutes() + now.getSeconds();
  }

  // To automatically get the dimensions of the poster image
  var onImgLoadEvent = function()
  {
    // Image is ready.
    var preview = this.previewImage;
    preview.removeListener( 'load', onImgLoadEvent );
    preview.removeListener( 'error', onImgLoadErrorEvent );
    preview.removeListener( 'abort', onImgLoadErrorEvent );

    this.setValueOf( 'info', 'width', preview.$.width );
    this.setValueOf( 'info', 'height', preview.$.height );
  };

  var onImgLoadErrorEvent = function()
  {
    // Error. Image is not loaded.
    var preview = this.previewImage;
    preview.removeListener( 'load', onImgLoadEvent );
    preview.removeListener( 'error', onImgLoadErrorEvent );
    preview.removeListener( 'abort', onImgLoadErrorEvent );
  };

  return {
    title : lang.dialogTitle,
    minWidth : 400,
    minHeight : 50,

    onShow : function()
    {
      // Clear previously saved elements.
      this.fakeImage = this.audioNode = null;
      // To get dimensions of poster image
      this.previewImage = editor.document.createElement( 'img' );

      var fakeImage = this.getSelectedElement();
      if ( fakeImage && fakeImage.data( 'cke-real-element-type' ) && fakeImage.data( 'cke-real-element-type' ) == 'audio' )
      {
        this.fakeImage = fakeImage;

        var audioNode = editor.restoreRealElement( fakeImage ),
          audios = [];

        audios.push( {src : audioNode.getAttribute( 'src' )} );

        this.audioNode = audioNode;

        this.setupContent( audioNode, audios );
      }
      else
        this.setupContent( null, [] );
    },

    onOk : function()
    {
      // If there's no selected element create one. Otherwise, reuse it
      var audioNode = null;
      if ( !this.fakeImage )
      {
        audioNode = CKEDITOR.dom.element.createFromHtml( '<cke:audio></cke:audio>', editor.document );
        audioNode.setAttributes(
          {
            controls: 'controls',
            src:  this.getValueOf( 'info', 'src0')
          } );
      }
      else
      {
        audioNode = this.audioNode;
      }

      var extraStyles = {}, audios = [];
      this.commitContent( audioNode, extraStyles, audios );

      var innerHtml = '', links = '',
        link = lang.linkTemplate || '',
        fallbackTemplate = lang.fallbackTemplate || '';

      links = link.replace('%src%', this.getValueOf('info', 'src0')).replace('%type%', this.getValueOf('info', 'src0').split('/').pop());
      audioNode.setHtml( innerHtml + fallbackTemplate.replace( '%links%', links ) );

      // Refresh the fake image.
      var newFakeImage = editor.createFakeElement( audioNode, 'cke_audio', 'audio', false );
      newFakeImage.setStyles( extraStyles );
      if ( this.fakeImage )
      {
        newFakeImage.replace( this.fakeImage );
        editor.getSelection().selectElement( newFakeImage );
      }
      else
        editor.insertElement( newFakeImage );
    },
    onHide : function()
    {
      if ( this.previewImage )
      {
        this.previewImage.removeListener( 'load', onImgLoadEvent );
        this.previewImage.removeListener( 'error', onImgLoadErrorEvent );
        this.previewImage.removeListener( 'abort', onImgLoadErrorEvent );
        this.previewImage.remove();
        this.previewImage = null;    // Dialog is closed.
      }
    },

    contents :
    [
      {
        id : 'info',
        elements :
        [
          {
            type : 'hbox',
            widths: [ '320px', '80px'],
            children : [
              {
                type : 'text',
                id : 'src0',
                label : lang.sourceAudio,
                commit : commitSrc,
                setup : loadSrc
              },
              {
                type : 'button',
                id : 'browse',
                hidden : 'true',
                style : 'display:inline-block;margin-top:10px;',
                filebrowser :
                {
                  action : 'Browse',
                  target: 'info:src0',
                  url: editor.config.filebrowserAudioBrowseUrl || editor.config.filebrowserBrowseUrl
                },
                label : editor.lang.esp_audio.browseServer
              }
              ]
          }
        ]
      }

    ]
  };
} );

