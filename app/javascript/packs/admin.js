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
import "@fortawesome/fontawesome-free/js/all";
require("@nathanvda/cocoon")

// Our JS stuff
import 'components/confirm_dialog';
import Translations from 'components/translations';
import Alert from 'components/alert';
import MarkdownEditor from 'components/markdown_editor'
import AdminPushmenuToggler from 'components/admin_pushmenu_toggler'
import PasswordVisibilityToggler from 'components/password_visibility_toggler'

// Our CSS Stuff
import 'stylesheets/admin'

Rails.start()
Turbolinks.start()
// ActiveStorage.start()

$(function() {
  Translations.setup();
})

document.addEventListener("turbolinks:load", () => {
  // TODO: add to component maybe?
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  });
  var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
  var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
    return new bootstrap.Popover(popoverTriggerEl)
  });
  Alert.hideAfterTimeout();
  MarkdownEditor.init(document.body);
  AdminPushmenuToggler.addListener();

  $('[data-component="PasswordVisibilityToggler"]').each((index, element) => {
    new PasswordVisibilityToggler(element);
  });
});
