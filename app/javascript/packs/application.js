// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

// Libraries
import 'bootstrap';
import "@fortawesome/fontawesome-free/css/all"

// Our stuff
import 'components/confirm_dialog';
import Translations from 'components/translations';
import Alert from 'components/alert';
import MarkdownEditor from 'components/markdown_editor'

$(function() {
  Translations.setup();
})

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  Alert.hideAfterTimeout();
  MarkdownEditor.init(document.body);
});
