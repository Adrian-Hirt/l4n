// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
// import * as ActiveStorage from "@rails/activestorage"
import "channels"

// Libraries
import 'bootstrap';
import "@fortawesome/fontawesome-free/js/all"

// Our JS stuff
import 'components/confirm_dialog';
import Translations from 'components/translations';
import Alert from 'components/alert';
import PasswordVisibilityToggler from 'components/password_visibility_toggler'
import ImageCropper from 'components/image_cropper';

// Our CSS Stuff
import 'stylesheets/application'

Rails.start()
Turbolinks.start()
// ActiveStorage.start()

$(function() {
  Translations.setup();
})

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  Alert.hideAfterTimeout();

  $('[data-component="PasswordVisibilityToggler"]').each((index, element) => {
    new PasswordVisibilityToggler(element);
  });

  $('[data-component="ImageCropper"]').each((index, element) => {
    new ImageCropper($(element));
  });
});
