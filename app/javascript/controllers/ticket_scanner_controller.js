import { Controller } from '@hotwired/stimulus';
import QrScanner from 'qr-scanner';
import JsAlert from '../utils/js_alert';
import Translations from '../components/translations';

export default class extends Controller {
  static targets = ['cameraSelector'];

  connect() {
    let videoElem = this.element.querySelector('video');

    // Setup qrScanner
    this.qrScanner = new QrScanner(
      videoElem,
      result => this.#processScanResult(result),
      {
        returnDetailedScanResult: true,
        highlightScanRegion: true,
        highlightCodeOutline: true
      }
    );

    this.cameraSelectorTarget.addEventListener('change', (e) => this.#setCamera(e));

    // List the cameras
    this.#listCameras();
  }

  #listCameras() {
    QrScanner.listCameras(true).then((result) => {
      if(result.length == 0) {
        // Return if no camera found
        return;
      }
      else {
        // Remove empty selection
        this.cameraSelectorTarget.innerHTML = null;
      }

      for(let camera of result) {
        // Add each camera to the selectable cameras
        let option = document.createElement('option');
        option.value = camera.id;
        option.innerHTML = camera.label;

        this.cameraSelectorTarget.appendChild(option);
      }
    });
  }

  #setCamera(e) {
    this.qrScanner.setCamera(e.target.value);
  }

  #processScanResult(result) {
    this.qrScanner.stop();

    // Parse the data from the QR scan
    let parsedData;
    try {
      parsedData = JSON.parse(result.data);
    }
    catch {
      // Show alert if parsing failed
      new JsAlert(Translations._('TicketScanner|Invalid QR code, please try again'), 'danger').show();
      return;
    }

    // Otherwise, get the id from the parsed data and request the
    // info data from the backend
    let qrIdInput = this.element.querySelector('#ticket_scanner_actions #qr_id');
    qrIdInput.value = parsedData.qr_id;

    // Submit the form to get the data from the backend
    let form = this.element.querySelector('#ticket_scanner_actions form');
    form.requestSubmit();
  }

  startScanning(e) {
    // Prevent button link follow
    e.preventDefault();

    // Start the qr code scanner
    this.qrScanner.start();
  }

  stopScanning(e) {
    // Prevent button link follow
    e.preventDefault();

    // Stop the qr code scanner
    this.qrScanner.stop();
  }

  toggleFlash(e) {
    // Prevent button link follow
    e.preventDefault();

    // Toggle the flash (if supported)
    this.qrScanner.toggleFlash();
  }
}
