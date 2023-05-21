import { Controller } from '@hotwired/stimulus';
import Translations from '../../components/translations';

export default class extends Controller {
  static targets = ['category'];

  connect() {
    this.options = JSON.parse(this.element.dataset.permissionToModesMap);
  }

  changeAvailableOptions(event) {
    let selectedOption = event.currentTarget.selectedOptions[0].value;
    let modeInput = event.currentTarget.closest('.row').querySelector('.user_user_permissions_mode > select');

    if (selectedOption) {
      let optStr = `<option value="">${ Translations._('Form|Select|Blank') }</option>`;

      for (let opt of this.options[selectedOption]) {
        optStr += `<option value="${opt}">${opt}</option>`;
      }

      modeInput.innerHTML = optStr;
      modeInput.disabled = false;
    }
    else {
      modeInput.innerHTML = `<option value="">${ Translations._('Userpermission|Please select a permission first') }</option>`;
      modeInput.disabled = true;
    }
  }
}