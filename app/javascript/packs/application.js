// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as Turbo from "@hotwired/turbo"
import "channels"

// Libraries
import 'bootstrap';
import "@fortawesome/fontawesome-free/css/all"

// Our stuff
import 'components/confirm_dialog';
import Translations from 'components/translations';
import Alert from 'components/alert';

Rails.start()
// ActiveStorage.start()

$(function() {
  Translations.setup();
});

document.addEventListener("turbo:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  Alert.hideAfterTimeout();
});
