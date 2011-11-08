(function () {
  var esp_attachmentCmd = {
    exec: function (editor) {
      editor.openDialog('esp_attachment');
      return
    }
  };
  CKEDITOR.plugins.add('esp_attachment', {
    lang: ['en', 'ru', 'uk'],
    requires: ['dialog'],
    init: function (editor) {
      var commandName = 'esp_attachment';
      editor.addCommand(commandName, esp_attachmentCmd);
      editor.ui.addButton('Esp_attachment', {
        label: editor.lang.esp_attachment.button,
        command: commandName,
        icon: this.path + "images/esp_attachment.png"
      });
      CKEDITOR.dialog.add(commandName, CKEDITOR.getUrl(this.path + 'dialogs/esp_attachment.js'))
    }
  })
})();

