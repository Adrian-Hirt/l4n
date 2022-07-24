import { Controller } from "@hotwired/stimulus"
import 'konva'
import 'sweetalert2'
import JsAlert from 'utils/js_alert'

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
    let currentLocation = window.location.pathname;
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
    this.seatsById = {};

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
        seatCategoryId: seat.seatCategoryId,
        taken: seat.taken
      });

      // Add the new box
      this.baseLayer.add(newSeat);

      // Add newly added seat to array of seats
      this.seats.push(newSeat);

      this.seatsById[seat.backendId] = newSeat;
    }

    this.#highlightSeats();
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
        this.#disableAddButtons();
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

      // if the seat is taken, we simply disable all buttons and return early
      if (this.currentSelection.attrs.taken) {
        this.#disableAddButtons();

        return;
      }

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

    // Enable all the "Change assignee" buttons
    this.ticketsTarget.querySelectorAll('.ticket > .btn.assign-seat-btn').forEach((item) => {
      item.addEventListener('click', (e) => {
        this.#openAssigningPopup(e.target);
      });
    });

        // Enable all the "Remove assignee" buttons
        this.ticketsTarget.querySelectorAll('.ticket > .btn.remove-assigned-seat-btn').forEach((item) => {
          item.addEventListener('click', (e) => {
            this.#removeAssignee(e.target);
          });
        });
  }

  // Method to get a seat with a ticket
  #getSeat(ticketButton) {
    let ticketId = ticketButton.parentElement.dataset.ticketId;
    let seatId = this.currentSelection.attrs.backendId;

    // Send the data
    const csrfToken = document.querySelector("[name='csrf-token']").content;

    let currentLocation = window.location.pathname;
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
        // Show flash
        new JsAlert(i18n._('SeatMap|Seat successfully taken'), 'success').show();

        // Highlight the seat as "taken"
        this.currentSelection.setAttr('fill', 'red');

        // Hide the "Get" button and show the "Remove" button
        ticketButton.classList.add('d-none');
        ticketButton.parentElement.querySelector('.remove-seat-btn').classList.remove('d-none');

        // Mark the seat as not taken
        this.currentSelection.setAttr('taken', true);

        // Update the ID in the ticket info
        ticketButton.parentElement.querySelector('.ticket-seat-id').innerHTML = this.currentSelection.attrs.backendId;

        // Disable the buttons and reset the current selected seat
        this.#disableAddButtons();
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

    let currentLocation = window.location.pathname;
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

      // Show flash
      new JsAlert(i18n._('SeatMap|Seat successfully removed'), 'success').show();

      // Hide the remove button, show the get button
      ticketButton.classList.add('d-none');
      ticketButton.parentElement.querySelector('.add-seat-btn').classList.remove('d-none');

      // "reset" the color of the seat
      let seat = this.seats.find(element => element.attrs.backendId == seatId);
      let seatColor = this.seatCategoryData[seat.attrs.seatCategoryId].color;
      seat.setAttr('fill', seatColor);

      // Mark the seat as not taken
      seat.setAttr('taken', false);

      // Update the ID in the ticket info
      ticketButton.parentElement.querySelector('.ticket-seat-id').innerHTML = '-';

      // Finally, disable the buttons
      this.#disableAddButtons();
      this.#unselectSeat();
    })
    .catch(error => {
      console.error("error", error);
    });
  }

  #openAssigningPopup(ticketButton) {
    let ticketId = ticketButton.parentElement.dataset.ticketId;

    const csrfToken = document.querySelector("[name='csrf-token']").content;
    let currentLocation = window.location.pathname;
    currentLocation = currentLocation.endsWith('/') ? currentLocation.slice(0, -1) : currentLocation;

    Sweetalert2.fire({
      title: i18n._('SeatMap|Change assignee of seat'),
      text:  i18n._('SeatMap|Please input the username of the user you want to assign the seat to'),
      input: 'text',
      inputAttributes: {
        autocapitalize: 'off'
      },
      showCancelButton: true,
      confirmButtonText: i18n._('SweetAlertForm|Save'),
      cancelButtonText: i18n._('SweetAlertForm|Cancel'),
      showLoaderOnConfirm: true,
      preConfirm: (search_string) => {
        let url = `${currentLocation}/user_by_username?username=${search_string}`;

        // Do lookup of user by username, return ID if ok.
        return fetch(url, {
          method: "GET"
        }).then(response => {
          if(response.ok) {
            return response.json();
          }
          else {
            throw new Error(response.statusText);
          }
        })
        .catch(_error => {
          Sweetalert2.showValidationMessage(i18n._('Seatmap|User not found'));
        });
      }
    }).then((result) => {
      if (result.isConfirmed && result.value.id) {
        let user_id = result.value.id;

        Sweetalert2.fire({
          title: i18n._('SeatMap|Change assignee of seat'),
          text:  i18n._('SeatMap|Do you want to assign the seat to ') + result.value.username + '?',
          showCancelButton: true,
          confirmButtonText: i18n._('SweetAlertForm|Assign seat'),
          cancelButtonText: i18n._('SweetAlertForm|Cancel'),
        }).then(result => {
          if (result.isConfirmed) {

            let postData = {
              ticket_id: ticketId,
              user_id:   user_id
            }

            let url = `${currentLocation}/assign_ticket`;

            fetch(url, {
              method: "POST",
              headers: {
                "X-CSRF-Token": csrfToken,
                "Content-Type": "application/json"
              },
              body: JSON.stringify(postData)
            }).then(response => {
              if(response.ok) {
                new JsAlert(i18n._('SeatMap|Ticket successfully assigned'), 'success').show();
              }
              else {
                new JsAlert(i18n._('SeatMap|Ticket could not be assigned'), 'danger').show();
              }
            });
          }
        });
      }
    });
  }

  #removeAssignee(ticketButton) {
    let ticketId = ticketButton.parentElement.dataset.ticketId;

    const csrfToken = document.querySelector("[name='csrf-token']").content;
    let currentLocation = window.location.pathname;
    currentLocation = currentLocation.endsWith('/') ? currentLocation.slice(0, -1) : currentLocation;

    let url = `${currentLocation}/remove_assignee?id=${ticketId}`;

    // Do lookup of user by username, return ID if ok.
    return fetch(url, {
      method: "DELETE",
      headers: {
        "X-CSRF-Token": csrfToken
      }
    }).then(response => {
      if(response.ok) {
        new JsAlert(i18n._('SeatMap|Assignee successfully removed'), 'success').show();
      }
      else {
        new JsAlert(i18n._('SeatMap|Assignee could not be removed'), 'danger').show();
      }
    });
  }

  #disableAddButtons() {
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

  #highlightSeats() {
    const urlParams = new URLSearchParams(window.location.search);
    const highlight = urlParams.getAll('highlight');

    if(highlight.length > 0) {
      for(let id of highlight) {
        this.seatsById[id]?.setAttr('fill', 'yellow');
      }
    }
  }
}
