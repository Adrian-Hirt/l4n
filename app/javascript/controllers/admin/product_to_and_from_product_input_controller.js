import { Controller } from '@hotwired/stimulus';
import Translations from '../../components/translations';

export default class extends Controller {
  static targets = ['fromProduct', 'toProduct'];

  connect() {
    this.options = JSON.parse(this.element.dataset.options);
  }

  changeAvailableOptions(event) {
    let selectedOption = event.currentTarget.selectedOptions[0].value;

    if (selectedOption) {
      let optStr = `<option value="">${ Translations._('Form|Select|Blank') }</option>`;

      for (let opt of this.options[selectedOption]) {
        optStr += `<option value="${opt.id}">${opt.name}</option>`;
      }

      this.fromProductTarget.innerHTML = optStr;
      this.fromProductTarget.disabled = false;
      this.toProductTarget.innerHTML = optStr;
      this.toProductTarget.disabled = false;
    }
    else {
      this.fromProductTarget.innerHTML = `<option value="">${ Translations._('Form|Select|Blank') }</option>`;
      this.fromProductTarget.disabled = true;
      this.toProductTarget.innerHTML = `<option value="">${ Translations._('Form|Select|Blank') }</option>`;
      this.toProductTarget.disabled = true;
    }
  }
}