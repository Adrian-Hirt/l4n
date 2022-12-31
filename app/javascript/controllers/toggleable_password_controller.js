import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['button', 'input'];

  toggle() {
    if (this.inputTarget.type == 'text') {
      this.inputTarget.type = 'password';
      this.buttonTarget.querySelector('svg').setAttribute('data-icon', 'eye-slash');
    }
    else if (this.inputTarget.type == 'password') {
      this.inputTarget.type = 'text';
      this.buttonTarget.querySelector('svg').setAttribute('data-icon', 'eye');
    }
  }
}
