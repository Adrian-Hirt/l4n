import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['participantType', 'teamSize'];

  connect() {
    if (this.hasParticipantTypeTarget) {
      var radios = this.participantTypeTarget.querySelectorAll('input[type=radio]');
      this.teamSizeInput = this.teamSizeTarget.querySelector('input');

      for(let radio of radios) {
        radio.addEventListener('change', (e) => {
          if(e.target.value == 'true') {
            this.teamSizeInput.disabled = true;
            this.teamSizeTarget.classList.add('d-none');
          }
          else {
            this.teamSizeInput.disabled = false;
            this.teamSizeTarget.classList.remove('d-none');
          }
        });
      }
    }
  }
}
