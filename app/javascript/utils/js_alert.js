export default class JsAlert {
  constructor(text, type) {
    this.text = text;
    this.type = type;
  }

  show() {
    let alert = document.createElement('div');

    // Add classes
    alert.classList.add('alert', `alert-${this.type}`, 'alert-dismissible', 'fade', 'show', 'notification-flash');

    // Add controller which will later remove the alert
    alert.dataset.controller = 'alert';

    // Add text and hide button
    alert.innerHTML = `${this.text} <button class='btn-close' data-bs-dismiss='alert'></button>`;

    // show the flash
    document.body.appendChild(alert);
  }
}
