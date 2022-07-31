let setupCountdownTimer = function() {
  let countdownElement = document.getElementsByClassName('countdown')[0];
  let endDatetime = new Date(countdownElement.dataset.time).getTime();
  let redirectPath = countdownElement.dataset.redirect;

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

    let domString = `${minutesLeft} minutes ${secondsLeft} seconds left to submit the order`
    countdownElement.innerHTML = domString;
  }, 1000)
}
