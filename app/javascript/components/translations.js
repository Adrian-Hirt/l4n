const i18n = require("gettext.js")();

export default class Translations {
  static available_locales =  ["en"];

  static loadTranslations() {
    for(let lang of Translations.available_locales) {
      fetch(`/locale/${lang}.json`)
        .then(response => response.json())
        .then(data => i18n.loadJSON(data, 'messages'));
    }
  }

  static setup() {
    this.loadTranslations();
  }

  static _(string) {
    return i18n.gettext(string);
  }
};
