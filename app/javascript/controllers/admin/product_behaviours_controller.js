import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    // Nothing to do
  }

  behavioursChanged(event) {
    let id = `#product-behaviour-${event.target.value}`;
    let behaviourElement = this.element.querySelector(id);

    // Toggle visibility of row
    behaviourElement.classList.toggle('d-none');

    // Toggle disabled status of the inputs
    let inputs = behaviourElement.querySelectorAll('input, textarea, select, checkbox');
    for (let input of inputs) {
      input.disabled = !input.disabled;
    }
  }
}