import i18n from 'gettext.js';

const i18nConst = i18n();

i18nConst._ = function(str) {
  return i18nConst.gettext(str);
}

export default class Translations {
  static available_locales =  ["en", "de"];

  static loadTranslations() {
    for(let lang of Translations.available_locales) {
      fetch(`/locale/${lang}.json`)
        .then(response => response.json())
        .then(data => i18nConst.loadJSON(data, 'messages'));
    }
  }

  static setup() {
    window.i18n = i18nConst;
    this.loadTranslations();
  }

  static _(str) {
    return i18nConst._(str);
  }
};
