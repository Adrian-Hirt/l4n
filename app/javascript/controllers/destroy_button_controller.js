import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    // Boolean wether the alert dialog has been confirmed or not
    this.confirmed = false;
  }

  confirm(event) {
    if(this.confirmed) {
      return true
    }

    event.preventDefault();
    let message = this.element.getAttribute('data-confirm');
    let text = this.element.getAttribute('data-text');

    Sweetalert2.fire({
      title: message,
      text: text || '',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: i18n._('ConfirmDialog|Confirm'),
      cancelButtonText: i18n._('ConfirmDialog|Cancel')
    }).then(result => {
      if(result.isConfirmed) {
        this.confirmed = true;
        this.element.click();
      }
    });
  }
}