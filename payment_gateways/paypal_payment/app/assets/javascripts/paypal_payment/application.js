let setupCountdownTimer = function() {
  let countdownElement = document.getElementsByClassName('countdown')[0];
  let endDatetime = new Date(countdownElement.dataset.time).getTime();
  let redirectPath = countdownElement.dataset.redirect;
  let timerElement = document.getElementById('time-left');

  setInterval(() => {
    let now = new Date().getTime();
    let remainingTime = endDatetime - now;
    let second = 1000;
    let minute = second * 60;
    let hour = minute * 60;
    minutesLeft = Math.trunc((remainingTime % hour) / minute);
    secondsLeft = Math.trunc((remainingTime % minute) / second);

    if (minutesLeft <= 0 && secondsLeft <= 0) {
      window.location.replace(redirectPath);
    }

    let domString = `${minutesLeft}:${String(secondsLeft).padStart(2, '0')}`;
    timerElement.innerHTML = domString;
  }, 1000)
};


let setupPaypalButton = function() {
  let buttonContainer = document.getElementById('paypal-button-container');

  let paymentCreateUrl = buttonContainer.dataset.paymentCreateUrl;
  let paymentExecuteUrl = buttonContainer.dataset.paymentExecuteUrl;
  let env = buttonContainer.dataset.production == 'true' ? 'production' : 'sandbox';

  // Render the paypal button
  paypal.Button.render({
    env: env,
    commit: 'true',
    style: {
      size: 'medium',
      color: 'gold',
      shape: 'rect',
      layout: 'horizontal',
      label: 'pay',
      tagline: false
    },
    locale: 'en_US',

    // payment() is called when the button is clicked
    payment: function() {
      // Make a call to your server to set up the payment
      return paypal.request.post(paymentCreateUrl)
                           .then((res) => {
                             if(res.status == 'ok') {
                              return res.paymentID;
                             }
                             else {
                              new JsAlert(res.message, 'danger').show();
                             }
                            });
    },

    // onAuthorize() is called when the buyer approves the payment
    onAuthorize: function(data, _actions) {
      // Set up the data you need to pass to your server
      let postData = {
        paymentID: data.paymentID,
        payerID: data.payerID
      };

      // Make a call to your server to execute the payment
      return paypal.request.post(paymentExecuteUrl, postData)
                           .then(function(res) {
                             if(res.status == 'ok') {
                              // Redirect back to shop
                              window.location.href = res.path;
                             }
                             else {
                              new JsAlert(res.message, 'danger').show();
                             }
                           });
    }
  }, '#paypal-button-container');
};

class JsAlert {
  constructor(text, type) {
    this.text = text;
    this.type = type;
  }

  show() {
    let alert = document.createElement("div");

    // Add classes
    alert.classList.add('alert', `alert-${this.type}`, 'alert-dismissible', 'fade', 'show', 'notification-flash');

    // Add controller which will later remove the alert
    alert.dataset.controller = 'alert';

    // Add text and hide button
    alert.innerHTML = `${this.text} <button class='btn-close' data-bs-dismiss='alert'></button>`

    // show the flash
    document.body.appendChild(alert);
  }
};