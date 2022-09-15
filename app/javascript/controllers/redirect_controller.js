import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect() {
    Turbo.visit(this.element.dataset.url)
  }
}