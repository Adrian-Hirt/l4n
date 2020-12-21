const gettext = require('gettext.js');
export const i18n = gettext.default();

const languages = ['en']; // Array of locales

export default class Translations {
  static loadTranslations() {
    for(let lang of languages) {
      let json_data = require('../locale/' + lang + '.json');
      i18n.loadJSON(json_data, 'messages');
    }
  }

  static setup() {
    window.i18n = i18n;
    this.loadTranslations();
  }
};
