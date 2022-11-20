import { Controller } from "@hotwired/stimulus"
import MarkdownEditor from '../../components/markdown_editor'

export default class extends Controller {
  connect() {
    new MarkdownEditor(this.element);
  }
}
