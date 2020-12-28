// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");

import 'bootstrap';
import 'components/confirm_dialog';
import Translations from 'components/translations';
import Alert from 'components/alert';
import 'components/markdown_editor'

$(function() {
  Translations.setup();
})

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  Alert.hideAfterTimeout();
});
