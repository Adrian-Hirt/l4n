import { Controller } from "@hotwired/stimulus"
import MarkdownEditor from '../../components/markdown_editor'

export default class extends Controller {
  connect() {
    setTimeout(() => {
      new MarkdownEditor(this.element);
    }, 100);
  }
}
