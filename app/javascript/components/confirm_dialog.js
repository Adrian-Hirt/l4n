import Rails from '@rails/ujs';
import sweetAlert from 'sweetalert2/dist/sweetalert2.all'

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

  sweetAlert.fire({
    title: message,
    text: text || '',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonText: 'Yes',
    cancelButtonText: 'Cancel',
  }).then(result => confirmed(element, result))
};

const allowAction = (element) => {
  if (element.getAttribute('data-confirm') === null) {
    return true
  }
console.log('12fg43e');
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