import EasyMDE from 'easymde';
import { i18n } from 'components/translations';
import sweetAlert from 'sweetalert2/dist/sweetalert2.all'
import { debounce } from 'utils/debounce';

export default class MarkdownEditor {
  constructor(domElement) {
    this.easyMDE = new EasyMDE({
      element: domElement,
      spellChecker: false,
      promptURLs: true,
      previewRender: this.previewRender,
      toolbar: [
        {
          name: "bold",
          action: EasyMDE.toggleBold,
          className: 'fa fa-bold',
          title: i18n._('MarkdownEditor|Toolbar|Bold')
        },
        {
          name: "italic",
          action: EasyMDE.toggleItalic,
          className: 'fa fa-italic',
          title: i18n._('MarkdownEditor|Toolbar|Italic')
        },
        {
          name: "strikethrough",
          action: EasyMDE.toggleStrikethrough,
          className: 'fa fa-strikethrough',
          title: i18n._('MarkdownEditor|Toolbar|Strikethrough')
        },
        {
          name: "heading",
          action: EasyMDE.toggleHeadingSmaller,
          className: 'fa fa-header',
          title: i18n._('MarkdownEditor|Toolbar|Heading')
        },
        {
          name: "highlight",
          action: this.highlight,
          className: 'fas fa-highlighter',
          title: i18n._('MarkdownEditor|Toolbar|Highlight text'),
        },
        "|",
        {
          name: "quote",
          action: EasyMDE.toggleBlockquote,
          className: 'fa fa-quote-left',
          title: i18n._('MarkdownEditor|Toolbar|Quote')
        },
        {
          name: "code",
          action: EasyMDE.toggleCodeBlock,
          className: 'fa fa-code',
          title: i18n._('MarkdownEditor|Toolbar|Code')
        },
        {
          name: "unordered-list",
          action: EasyMDE.toggleUnorderedList,
          className: 'fa fa-list-ul',
          title: i18n._('MarkdownEditor|Toolbar|Unordered list')
        },
        {
          name: "ordered-list",
          action: EasyMDE.toggleOrderedList,
          className: 'fa fa-list-ol',
          title: i18n._('MarkdownEditor|Toolbar|Ordered list')
        },
        {
          name: "clean-block",
          action: EasyMDE.cleanBlock,
          className: 'fa fa-eraser',
          title: i18n._('MarkdownEditor|Toolbar|Clean block')
        },
        "|",
        {
          name: 'link',
          action: this.insertLink,
          className: 'fa fa-link',
          title:  i18n._('MarkdownEditor|Toolbar|Insert link')
        },
        {
          name: 'image',
          action: this.insertImage,
          className: 'fa fa-image',
          title:  i18n._('MarkdownEditor|Toolbar|Insert image')
        },
        {
          name: "table",
          action: EasyMDE.drawTable,
          className: 'fa fa-table',
          title: i18n._('MarkdownEditor|Toolbar|Insert table')
        },
        {
          name: "horizontal-rule",
          action: EasyMDE.drawHorizontalRule,
          className: 'fa fa-minus',
          title: i18n._('MarkdownEditor|Toolbar|Insert horizontal rule')
        },
        "|",
        {
          name: "insertIcon",
          action: this.insertIcon,
          className: "fa fa-font-awesome",
          title: i18n._('MarkdownEditor|Toolbar|Insert an icon')
        },
        {
          name: "youtubeVideo",
          action: this.insertYoutubeVideo,
          className: "fa fa-youtube-square",
          title: i18n._('MarkdownEditor|Toolbar|Insert a Youtube video')
        },
        {
          name: "googleMaps",
          action: this.insertGoogleMaps,
          className: "fa fa-map",
          title: i18n._('MarkdownEditor|Toolbar|Insert map')
        },
        "|",
        {
          name: "preview",
          action: EasyMDE.togglePreview,
          className: 'fa fa-eye',
          title: i18n._('MarkdownEditor|Toolbar|Toggle preview')
        },
        {
          name: "side-by-side",
          action: this.debouncedToggleSideBySide,
          className: "fa fa-columns no-disable no-mobile",
          title: i18n._('MarkdownEditor|Toolbar|Show side-by-side preview')
        },
        {
          name: "fullscreen",
          action: EasyMDE.toggleFullScreen,
          className: 'fa fa-arrows-alt',
          title: i18n._('MarkdownEditor|Toolbar|Toggle full screen')
        },
        "|",
        {
          name: "iconInfo",
          action: this.showIconInfo,
          className: "fa fa-info-circle",
          title: i18n._('MarkdownEditor|Toolbar|Need help with the icons?')
        }
      ]
    });
  }

  previewRender(plainText, previewContainer) {
    return plainText;
  }

  debouncedToggleSideBySide(editor) {
    // Call the original toggleSideBySide
    editor.toggleSideBySide();

    var cm = editor.codemirror;

    // Create a callback function that we can use to update the preview
    var updateCallback = function() {
      var wrapper = cm.getWrapperElement();
      var preview = wrapper.nextSibling;
      var newValue = editor.options.previewRender(editor.value(), preview);
      preview.innerHTML = newValue;
    }

    // Disable the old callback
    cm.off('update', cm.sideBySideRenderingFunction);

    // And enable our update callback, debounced to 2000 ms
    cm.on('update', debounce(updateCallback, 2000));
  }

  highlight(editor) {
    var cm = editor.codemirror;
    var output = '';
    var str = cm.getSelection();
    if(str.length == 0) {
      output = '== ==';
      cm.replaceSelection(output);
      return;
    }

    if(str.substring(0, 2) == '==' && str.substring(str.length - 2, str.length) == '==') {
      output = str.substring(2, str.length - 2);
    }
    else {
      var text = str;
      output = '==' + text + '==';
    }
    cm.replaceSelection(output);
  }

  insertIcon(editor) {
    sweetAlert.fire({
      title: i18n._('MarkdownEditor|Popup|Insert icon'),
      text:  i18n._('MarkdownEditor|Popup|Please enter the name of the icon you want to use. If you need help with the names of the icons, click on the i button in the editor!'),
      input: 'text',
      showCancelButton: true,
      confirmButtonText: i18n._('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n._('MarkdownEditor|Popup|Cancel'),
    }).then(result => {
      if (result.isConfirmed) {
        var icon = result.value;
        if (icon == null) {
          return;
        }
        var cm = editor.codemirror;
        if(icon.substring(0, 3) == "fa-") {
          icon = icon.substring(3, icon.length);
        }
        var output = "{{" + icon + "}}";
        cm.replaceSelection(output);
      }
    })
  }

  insertYoutubeVideo(editor) {
    sweetAlert.fire({
      title: i18n._('MarkdownEditor|Popup|Insert youtube video'),
      text:  i18n._("MarkdownEditor|Popup|Please paste the URL of the youtube video here. The URL needs to be of format 'https://www.youtube.com/watch?v='"),
      input: 'text',
      showCancelButton: true,
      confirmButtonText: i18n._('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n._('MarkdownEditor|Popup|Cancel'),
    }).then(result => {
      if (result.isConfirmed) {
        var url = result.value;
        if (url == null) {
          return;
        }
        var cm = editor.codemirror;
        var output = "{iframe}(" + url + ")";
        cm.replaceSelection(output);
      }
    })
  }

  insertGoogleMaps(editor) {
    sweetAlert.fire({
      title: i18n._('MarkdownEditor|Popup|Insert Google Maps Map'),
      text:  i18n._("MarkdownEditor|Popup|Please paste the URL of the map you want to share here! The URL needs to be of format 'https://www.google.com/maps/d/embed?mid=' or 'https://www.google.com/maps/embed?pb='"),
      input: 'text',
      showCancelButton: true,
      confirmButtonText: i18n._('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n._('MarkdownEditor|Popup|Cancel'),
    }).then(result => {
      if (result.isConfirmed) {
        var url = result.value;
        if (url == null) {
          return;
        }
        var cm = editor.codemirror;
        var output = "{iframe}(" + url + ")";
        cm.replaceSelection(output);
      }
    })
  }

  showIconInfo(editor) {
    window.open("https://fontawesome.com/v5.15.1/icons?d=gallery&m=free");
  }

  insertLink(editor) {
    sweetAlert.fire({
      title: i18n._('MarkdownEditor|Popup|Please enter your link'),
      input: 'text',
      inputPlaceholder: 'https://',
      showCancelButton: true,
      confirmButtonText: i18n._('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n._('MarkdownEditor|Popup|Cancel'),
    }).then(result => {
      if (result.isConfirmed) {
        var url = result.value;
        var cm = editor.codemirror;
        var str = cm.getSelection();
        var output = '[' + str + '](' + url + ')';
        cm.replaceSelection(output);
      }
    })
  }

  insertImage(editor) {
    sweetAlert.fire({
      title: i18n._('MarkdownEditor|Popup|Please enter the URL of the image'),
      input: 'text',
      inputPlaceholder: 'https://',
      showCancelButton: true,
      confirmButtonText: i18n._('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n._('MarkdownEditor|Popup|Cancel'),
    }).then(result => {
      if (result.isConfirmed) {
        var url = result.value;
        var cm = editor.codemirror;
        var str = cm.getSelection();
        var output = '![' + str + '](' + url + ')';
        cm.replaceSelection(output);
      }
    })
  }

  // TODO: Change this to maybe requiring a 'data' element set on the textarea
  static init(body) {
    $(body).find('textarea').each(function(el) {
      new MarkdownEditor(el);
    });
  }
}
