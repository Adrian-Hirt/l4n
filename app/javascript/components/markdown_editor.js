import { debounce } from "../utils/debounce"
import { rectanglesLoader } from '../components/loading_animations'
import EasyMDE from 'easymde'
import 'sweetalert2'

const i18n = require("gettext.js")();

export default class MarkdownEditor extends EasyMDE {
  // Constructs our markdown editor, which extends the EasyMDE editor
  constructor(domElement) {
    super({
      toolbar: MarkdownEditor.constructToolbar(),
      promptURLs: true,
      spellChecker: false,
      previewRender: MarkdownEditor.previewRender,
      minHeight: '150px',
      autoDownloadFontAwesome: false
    });

    this.previewUrl = domElement.dataset.previewUrl;
  }

  // Render the markdown for preview.
  static previewRender(plainText, previewContainer) {
    var self = this;
    let csrfToken = document.querySelector("[name='csrf-token']").content;

    // We need to use a timeout of 1 ms before we check if the preview
    // is active, as the EasyMDE only adds the active class after a delay
    // of 1 ms
    setTimeout(function () {
      if (!(self.parent.isPreviewActive() || self.parent.isSideBySideActive())) {
        return null;
      }

      // Get the url from the parent
      var url = self.parent.previewUrl;

      fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify(plainText)
      })
      .then(response => response.json())
      .then(data => {
        previewContainer.innerHTML = data;
      })
      .catch((error) => {
        console.error('Error:', error);
        Sweetalert2.fire({
          title: i18n.gettext('MarkdownEditor|Rendering preview failed'),
          icon: 'error',
          confirmButtonText: i18n.gettext('ConfirmDialog|Confirm')
        });
      });
    }, 1);

    // While our AJAX call is still loading, display the loading animation
    return "<div class='markdownPreviewLoading'>" + rectanglesLoader() + "</div>";
  }

  // Our toggle side by side uses a debounced version of the preview
  // render, as we don't want to update the preview with every update
  static debouncedToggleSideBySide(editor) {
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


  // Constructs the toolbar, with the correct methods and localized titles
  static constructToolbar() {
    return [
      {
        name: "bold",
        action: EasyMDE.toggleBold,
        className: 'fa fa-bold',
        title: i18n.gettext('MarkdownEditor|Toolbar|Bold')
      },
      {
        name: "italic",
        action: EasyMDE.toggleItalic,
        className: 'fa fa-italic',
        title: i18n.gettext('MarkdownEditor|Toolbar|Italic')
      },
      {
        name: "strikethrough",
        action: EasyMDE.toggleStrikethrough,
        className: 'fa fa-strikethrough',
        title: i18n.gettext('MarkdownEditor|Toolbar|Strikethrough')
      },
      {
        name: "heading",
        action: EasyMDE.toggleHeadingSmaller,
        className: 'fa fa-heading',
        title: i18n.gettext('MarkdownEditor|Toolbar|Heading')
      },
      {
        name: "highlight",
        action: MarkdownEditor.highlight,
        className: 'fas fa-highlighter',
        title: i18n.gettext('MarkdownEditor|Toolbar|Highlight text'),
      },
      "|",
      {
        name: "quote",
        action: EasyMDE.toggleBlockquote,
        className: 'fa fa-quote-left',
        title: i18n.gettext('MarkdownEditor|Toolbar|Quote')
      },
      {
        name: "code",
        action: EasyMDE.toggleCodeBlock,
        className: 'fa fa-code',
        title: i18n.gettext('MarkdownEditor|Toolbar|Code')
      },
      {
        name: "unordered-list",
        action: EasyMDE.toggleUnorderedList,
        className: 'fa fa-list-ul',
        title: i18n.gettext('MarkdownEditor|Toolbar|Unordered list')
      },
      {
        name: "ordered-list",
        action: EasyMDE.toggleOrderedList,
        className: 'fa fa-list-ol',
        title: i18n.gettext('MarkdownEditor|Toolbar|Ordered list')
      },
      {
        name: "clean-block",
        action: EasyMDE.cleanBlock,
        className: 'fa fa-eraser',
        title: i18n.gettext('MarkdownEditor|Toolbar|Clean block')
      },
      "|",
      {
        name: 'link',
        action: MarkdownEditor.insertLink,
        className: 'fa fa-link',
        title:  i18n.gettext('MarkdownEditor|Toolbar|Insert link')
      },
      {
        name: 'image',
        action: MarkdownEditor.insertImage,
        className: 'fa fa-image',
        title:  i18n.gettext('MarkdownEditor|Toolbar|Insert image')
      },
      {
        name: "button-table",
        action: EasyMDE.drawTable,
        className: 'fa fa-table',
        title: i18n.gettext('MarkdownEditor|Toolbar|Insert table')
      },
      {
        name: "horizontal-rule",
        action: EasyMDE.drawHorizontalRule,
        className: 'fa fa-minus',
        title: i18n.gettext('MarkdownEditor|Toolbar|Insert horizontal rule')
      },
      "|",
      {
        name: "insertIcon",
        action: MarkdownEditor.insertIcon,
        className: "fa fa-icons",
        title: i18n.gettext('MarkdownEditor|Toolbar|Insert an icon')
      },
      {
        name: "youtubeVideo",
        action: MarkdownEditor.insertYoutubeVideo,
        className: "fab fa-youtube",
        title: i18n.gettext('MarkdownEditor|Toolbar|Insert a Youtube video')
      },
      {
        name: "googleMaps",
        action: MarkdownEditor.insertGoogleMaps,
        className: "fa fa-map",
        title: i18n.gettext('MarkdownEditor|Toolbar|Insert map')
      },
      "|",
      {
        name: "preview",
        action: EasyMDE.togglePreview,
        className: 'fa fa-eye no-disable no-mobile',
        title: i18n.gettext('MarkdownEditor|Toolbar|Toggle preview')
      },
      // {
      //   name: "side-by-side",
      //   action: MarkdownEditor.debouncedToggleSideBySide,
      //   className: "fa fa-columns no-disable no-mobile",
      //   title: i18n.gettext('MarkdownEditor|Toolbar|Show side-by-side preview')
      // },
      // {
      //   name: "fullscreen",
      //   action: EasyMDE.toggleFullScreen,
      //   className: 'fa fa-arrows-alt no-disable no-mobile',
      //   title: i18n.gettext('MarkdownEditor|Toolbar|Toggle full screen')
      // },
      "|",
      {
        name: "iconInfo",
        action: MarkdownEditor.showIconInfo,
        className: "fa fa-info-circle",
        title: i18n.gettext('MarkdownEditor|Toolbar|Need help with the icons?')
      }
    ]
  }

  // Highlight text in markdown
  static highlight(editor) {
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

  // Insert a font awesome icon
  static insertIcon(editor) {
    Sweetalert2.fire({
      title: i18n.gettext('MarkdownEditor|Popup|Insert icon'),
      text:  i18n.gettext('MarkdownEditor|Popup|Please enter the name of the icon you want to use. If you need help with the names of the icons, click on the i button in the editor!'),
      input: 'text',
      showCancelButton: true,
      confirmButtonText: i18n.gettext('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n.gettext('MarkdownEditor|Popup|Cancel'),
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

  // Insert a youtube video as an iframe
  static insertYoutubeVideo(editor) {
    Sweetalert2.fire({
      title: i18n.gettext('MarkdownEditor|Popup|Insert youtube video'),
      text:  i18n.gettext("MarkdownEditor|Popup|Please paste the URL of the youtube video here. The URL needs to be of format 'https://www.youtube.com/watch?v='"),
      input: 'text',
      showCancelButton: true,
      confirmButtonText: i18n.gettext('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n.gettext('MarkdownEditor|Popup|Cancel'),
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

  // Insert a google maps map as an iframe
  static insertGoogleMaps(editor) {
    Sweetalert2.fire({
      title: i18n.gettext('MarkdownEditor|Popup|Insert Google Maps Map'),
      text:  i18n.gettext("MarkdownEditor|Popup|Please paste the URL of the map you want to share here! The URL needs to be of format 'https://www.google.com/maps/d/embed?mid=' or 'https://www.google.com/maps/embed?pb='"),
      input: 'text',
      showCancelButton: true,
      confirmButtonText: i18n.gettext('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n.gettext('MarkdownEditor|Popup|Cancel'),
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

  // Opens a window with a list of the fontawesome icons
  static showIconInfo(editor) {
    window.open("https://fontawesome.com/v6.0/icons?m=free");
  }

  // Insert a link. Instead of the browser prompt, we'll use the sweetalert
  // popup, as this looks way better
  static insertLink(editor) {
    Sweetalert2.fire({
      title: i18n.gettext('MarkdownEditor|Popup|Please enter your link'),
      input: 'text',
      inputPlaceholder: 'https://',
      showCancelButton: true,
      confirmButtonText: i18n.gettext('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n.gettext('MarkdownEditor|Popup|Cancel'),
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

  // Insert an image. Instead of the browser prompt, we'll use the sweetalert
  // popup, as this looks way better
  static insertImage(editor) {
    Sweetalert2.fire({
      title: i18n.gettext('MarkdownEditor|Popup|Please enter the URL of the image'),
      input: 'text',
      inputPlaceholder: 'https://',
      showCancelButton: true,
      confirmButtonText: i18n.gettext('MarkdownEditor|Popup|Confirm'),
      cancelButtonText: i18n.gettext('MarkdownEditor|Popup|Cancel'),
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
}
