import { Controller } from "@hotwired/stimulus"
import MarkdownEditor from '../../components/markdown_editor'

export default class extends Controller {
  connect() {
    this.#removeOldEditor();

    setTimeout(() => {
      new MarkdownEditor(this.element);
    }, 100);
  }

  #removeOldEditor() {
    let nextSibling = this.element.nextElementSibling;

    if(!nextSibling) {
      return;
    }

    if(nextSibling.classList.contains('EasyMDEContainer')) {
      nextSibling.remove();
    }
  }
}
