import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    const event = new Event('l4n:seatmap-possibly-changed');
    document.dispatchEvent(event);
  }
}