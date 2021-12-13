import Rails from '@rails/ujs';
import { i18n } from 'components/translations';
import 'sweetalert2'

const confirmed = (element, result) => {
  if (result.value) {
    // User clicked confirm button
    element.removeAttribute('data-confirm')
    element.click()
  }
}

// Display the confirmation dialog
const showConfirmationDialog = (element) => {
  const message = element.getAttribute('data-confirm')
  const text = element.getAttribute('data-text')

  Sweetalert2.fire({
    title: message,
    text: text || '',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: i18n._('ConfirmDialog|Confirm'),
    cancelButtonText: i18n._('ConfirmDialog|Cancel'),
  }).then(result => confirmed(element, result))
};

const allowAction = (element) => {
  if (element.getAttribute('data-confirm') === null) {
    return true
  }
  showConfirmationDialog(element)
  return false
};

function handleConfirm(element) {
  if (!allowAction(element)) {
    Rails.stopEverything(element)
  }
};

Rails.confirm = function (message, element) {
  handleConfirm(element);
};