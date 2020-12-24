export default class Alert {
  static hideAfterTimeout() {
    setTimeout(function () { 
      $('.notification-flash').alert('close'); 
    }, 7500); 
  }
};