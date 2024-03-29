import { Controller } from '@hotwired/stimulus';
import Sweetalert2 from 'sweetalert2';
import Translations from '../components/translations';

export default class extends Controller {
  connect() {
    // Boolean wether the alert dialog has been confirmed or not
    this.confirmed = false;
  }

  confirmAction(event) {
    if(this.confirmed) {
      return true;
    }

    event.preventDefault();
    let message = this.element.getAttribute('data-confirm');
    let text = this.element.getAttribute('data-text');

    Sweetalert2.fire({
      title: message,
      text: text || '',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: Translations._('ConfirmDialog|Confirm'),
      cancelButtonText: Translations._('ConfirmDialog|Cancel')
    }).then(result => {
      if(result.isConfirmed) {
        this.confirmed = true;
        this.element.click();
      }
    });
  }

  disable() {
    this.element.classList.add('disabled');
  }
}