const gettext = require('gettext.js');
export const i18n = gettext.default();

import {available_locales} from 'components/locales.js.erb';

i18n._ = function(str) {
  return i18n.gettext(str);
}

export default class Translations {
  static loadTranslations() {
    for(let lang of available_locales) {
      let json_data = require('../locale/' + lang + '.json');
      i18n.loadJSON(json_data, 'messages');
    }
  }

  static setup() {
    window.i18n = i18n;
    this.loadTranslations();
  }
};
