import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    window.Turbo.visit(this.element.dataset.url);
  }
}