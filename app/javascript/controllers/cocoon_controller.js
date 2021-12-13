import { Controller } from '@hotwired/stimulus'
import Cocoon from 'components/cocoon';

export default class extends Controller {
  addRow(event) {
    Cocoon.cocoonAddFields(event, event.currentTarget);
  }

  removeRow(event) {
    Cocoon.cocoonRemoveFields(event, event.currentTarget);
  }
}
