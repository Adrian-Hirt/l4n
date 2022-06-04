import { Controller } from "@hotwired/stimulus"
import 'konva'
import 'sweetalert2'

export default class extends Controller {
  static targets = ['container', 'dummyButton', 'currentSelectedSeatInfo', 'tickets'];

  connect() {
    // Setup the base
    this.#setupBase();

    // Setup interactions
    this.#setupZoomFunctionality();
    this.#setupSeatSelectionFunctionality();

    // Load seats from the data
    this.#loadSeats();
  }

  #loadSeats() {
    let currentLocation = document.URL
    currentLocation = currentLocation.endsWith('/') ? currentLocation.slice(0, -1) : currentLocation;
    let url = `${currentLocation}/seats.json`;

    fetch(url)
      .then(response => response.json())
      .then((data) => this.#initSeats(data.seats))
      .catch(error => console.error("error", error));
  }

  #initSeats(seatData) {
    // Store all the seats in a field
    this.seats = [];

    for (let seat of seatData) {
      let newSeat = new Konva.Rect({
        x: seat.x,
        y: seat.y,
        width: seat.width,
        height: seat.height,
        backendId: seat.backendId,
        rotation: seat.rotation,
        scaleX: seat.scaleX,
        scaleY: seat.scaleY,
        fill: seat.color,
        draggable: false,
        name: 'seatRect',
        seatCategoryId: seat.seatCategoryId
      });

      // Add the new box
      this.baseLayer.add(newSeat);

      this.seats.push(newSeat);
    }
  }

  // Setup the base of the seatmap
  #setupBase() {
    // Get the base data
    this.seatmapData = JSON.parse(this.containerTarget.dataset.seatmapData);
    this.seatCategoryData = this.seatmapData.categories;

    // Setup the stage
    this.stage = new Konva.Stage({
      container: this.containerTarget,
      width: this.seatmapData.canvasWidth,
      height: this.seatmapData.canvasHeight,
      draggable: true
    });

    // Add base layer
    this.baseLayer = new Konva.Layer();
    this.stage.add(this.baseLayer);

    // Add background image
    const image = new window.Image();

    image.onload = () => {
      this.background = new Konva.Rect({
        x: 0,
        y: 0,
        width: this.seatmapData.backgroundWidth,
        height: this.seatmapData.backgroundHeight,
        fillPatternImage: image,
        fillPatternRepeat: "no-repeat",
        draggable: false
      });

      // Add the background to the base layer
      this.baseLayer.add(this.background);

      // And move the background to the bottom of the stack
      this.background.moveToBottom();
    }

    // Set source of image
    image.src = this.seatmapData.backgroundUrl;
  }

  #setupZoomFunctionality() {
    let scaleBy = 1.1;

    this.stage.on('wheel', (e) => {
      // stop default scrolling
      e.evt.preventDefault();

      let oldScale = this.stage.scaleX();
      let pointer = this.stage.getPointerPosition();

      let mousePointTo = {
        x: (pointer.x - this.stage.x()) / oldScale,
        y: (pointer.y - this.stage.y()) / oldScale,
      };

      // how to scale? Zoom in? Or zoom out?
      let direction = e.evt.deltaY < 0 ? 1 : -1;

      // when we zoom on trackpad, e.evt.ctrlKey is true
      // in that case lets revert direction
      if (e.evt.ctrlKey) {
        direction = -direction;
      }

      let newScale = direction > 0 ? oldScale * scaleBy : oldScale / scaleBy;

      this.stage.scale({ x: newScale, y: newScale });

      let newPos = {
        x: pointer.x - mousePointTo.x * newScale,
        y: pointer.y - mousePointTo.y * newScale,
      };

      this.stage.position(newPos);
    });
  }

  #setupSeatSelectionFunctionality() {
    this.stage.on('mouseup', (e) => {
      if (e.target === this.stage || e.target === this.background) {
        this.#disableButtons();
        this.#unselectSeat();

        return;
      }

      // Reset previous seat
      if(this.currentSelection) {
        this.currentSelection.setAttr('strokeWidth', 0);
      }

      // Store current selection
      this.currentSelection = e.target;

      // Highlight the current selection
      this.currentSelection.setAttr('stroke', 'black');
      this.currentSelection.setAttr('strokeWidth', 10);

      // Enable the tickets with which the user can get the current seat
      for(let ticket of this.ticketsTarget.querySelectorAll('.ticket')) {
        let ticketCategory = ticket.dataset.seatCategoryId;

        if(ticketCategory == this.currentSelection.attrs.seatCategoryId) {
          ticket.querySelector('.btn.add-seat-btn').classList.remove('disabled');
        }
        else {
          ticket.querySelector('.btn.add-seat-btn').classList.add('disabled');
        }
      }

      return false;
    });

    // Enable all the "Get" buttons
    this.ticketsTarget.querySelectorAll('.ticket > .btn.add-seat-btn').forEach((item) => {
      item.addEventListener('click', (e) => {
        this.#getSeat(e.target);
      });
    });

    // Enable all the "Remove" buttons
    this.ticketsTarget.querySelectorAll('.ticket > .btn.remove-seat-btn').forEach((item) => {
      item.addEventListener('click', (e) => {
        this.#removeSeat(e.target);
      });
    });
  }

  // Method to get a seat with a ticket
  #getSeat(ticketButton) {
    let ticketId = ticketButton.parentElement.dataset.ticketId;
    let seatId = this.currentSelection.attrs.backendId;

    // Send the data
    const csrfToken = document.querySelector("[name='csrf-token']").content;

    let currentLocation = document.URL
    currentLocation = currentLocation.endsWith('/') ? currentLocation.slice(0, -1) : currentLocation;
    let url = `${currentLocation}/get_seat`;

    let postData = {
      seat_id:   seatId,
      ticket_id: ticketId
    }

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json"
      },
      body: JSON.stringify(postData)
    }).then(response => {
      if(response.ok) {
        // Highlight the seat as "taken"
        this.currentSelection.setAttr('fill', 'red');

        // Hide the "Get" button and show the "Remove" button
        ticketButton.classList.add('d-none');
        ticketButton.parentElement.querySelector('.remove-seat-btn').classList.remove('d-none');

        // Disable the buttons and reses the current selected seat
        this.#disableButtons();
        this.#unselectSeat();
      }
      else {
        Sweetalert2.fire({
          title: i18n._('SeatMap|An error occured, please try again!'),
          icon: 'error',
          confirmButtonText: i18n._('ConfirmDialog|Confirm')
        });
      }
    }).catch(error => {
      console.error("error", error);
    });
  }

  // Method to remove a seat with a ticket
  #removeSeat(ticketButton) {
    let ticketId = ticketButton.parentElement.dataset.ticketId;

    // Send the data
    const csrfToken = document.querySelector("[name='csrf-token']").content;

    let currentLocation = document.URL
    currentLocation = currentLocation.endsWith('/') ? currentLocation.slice(0, -1) : currentLocation;
    let url = `${currentLocation}/remove_seat`;

    let postData = {
      ticket_id: ticketId
    }

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json"
      },
      body: JSON.stringify(postData)
    }).then(response => {
      if(response.ok) {
        return response.json();
      }
      else {
        Sweetalert2.fire({
          title: i18n._('SeatMap|An error occured, please try again!'),
          icon: 'error',
          confirmButtonText: i18n._('ConfirmDialog|Confirm')
        });
        return Promise.reject(response);
      }
    })
    .then(result => {
      let seatId = result.seatId;

      // Hide the remove button, show the get button
      ticketButton.classList.add('d-none');
      ticketButton.parentElement.querySelector('.add-seat-btn').classList.remove('d-none');

      let seat = this.seats.find(element => element.attrs.backendId == seatId);
      let seatColor = this.seatCategoryData[seat.attrs.seatCategoryId].color;
      seat.setAttr('fill', seatColor);
      this.#disableButtons();
      this.#unselectSeat();
    })
    .catch(error => {
      console.error("error", error);
    });
  }

  #disableButtons() {
    this.ticketsTarget.querySelectorAll('.ticket > .btn.add-seat-btn').forEach((item) => {
      item.classList.add('disabled');
    });
  }

  #unselectSeat() {
    if(this.currentSelection) {
      this.currentSelection.setAttr('strokeWidth', 0);
      this.currentSelection = null;
    }
  }
}
