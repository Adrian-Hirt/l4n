import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['category'];

  connect() {
    this.options = JSON.parse(this.element.dataset.options);
  }

  changeAvailableOptions(event) {
    let selectedOption = event.currentTarget.selectedOptions[0].value;

    if (selectedOption) {
      let optStr = `<option value="">${ i18n._('Form|Select|Blank') }</option>`;

      for (let opt of this.options[selectedOption]) {
        console.log(opt);
        optStr += `<option value="${opt.id}">${opt.name}</option>`
      }

      this.categoryTarget.innerHTML = optStr;
      this.categoryTarget.disabled = false;
    }
    else {
      this.categoryTarget.innerHTML = `<option value="">${ i18n._('Form|Select|Blank') }</option>`;
      this.categoryTarget.disabled = true;
    }
  }
}