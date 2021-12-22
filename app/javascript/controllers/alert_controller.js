import { Controller } from '@hotwired/stimulus'
import * as bootstrap from "bootstrap"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.remove();
    }, 7500);
  }
}
