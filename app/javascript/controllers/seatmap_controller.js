import { Controller } from "@hotwired/stimulus"
import 'konva'

export default class extends Controller {
  static targets = [
                    'container',
                    'tickets',
                    'currentSelectedSeatInfo',
                    'sidebarToggle',
                    'sidebar',
                    'mainColumn'
                  ];

  connect() {
    // Setup the base
    this.#setupBase();

    // Setup interactions
    this.#setupZoomFunctionality();
    this.#setupSeatSelectionFunctionality();

    // Load seats from the data
    this.#loadSeats();

    document.addEventListener('l4n:seatmap-possibly-changed', () => {
      this.#updateSeatMap();
    });

    // Setup sidebar toggler
    this.sidebarVisible = true;
    this.sidebarToggleTarget.addEventListener('click', (e) => this.#toggleSidebar(e));
  }

  #updateSeatMap() {
    let removedId = document.querySelector('#removedSeat')?.dataset?.id;
    let takenId = document.querySelector('#takenSeat')?.dataset?.id;
    let assignedSeatDataset = document.querySelector('#assignedSeat')?.dataset;
    let unassignedSeatId = document.querySelector('#unassignedSeat')?.dataset?.id;

    if(removedId) {
      // "reset" the color of the seat
      let seat = this.seats.find(element => element.attrs.backendId == removedId);
      let seatColor = this.seatCategoryData[seat.attrs.seatCategoryId].color;
      seat.setAttr('fill', seatColor);

      // Mark the seat as not taken
      seat.setAttr('taken', false);
    }
    else if(takenId) {
      // Highlight the seat as "taken"
      let seat = this.seats.find(element => element.attrs.backendId == takenId);
      seat.setAttr('fill', 'red');

      // Mark the seat as taken
      seat.setAttr('taken', true);
    }

    if(assignedSeatDataset?.id) {
      let seat = this.seats.find(element => element.attrs.backendId == assignedSeatDataset.id);
      seat.setAttr('userName', assignedSeatDataset.username);
      seat.setAttr('userId', assignedSeatDataset.userid);
    }

    if(unassignedSeatId) {
      let seat = this.seats.find(element => element.attrs.backendId == unassignedSeatId);
      seat.setAttr('userName', null);
      seat.setAttr('userId', null);
    }

    this.#unselectSeat();
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
        taken: seat.taken,
        userName: seat.userName,
        userId: seat.userId
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

      this.#updateSelectedSeatInfo();

      // if the seat is taken, we simply disable all buttons and return early
      if (this.currentSelection.attrs.taken) {
        this.#disableAddButtons();

        return;
      }

      // Update the seatId in all selectedSeatInputs
      for(let input of this.ticketsTarget.querySelectorAll('input.selected-seat-input')) {
        input.value = this.currentSelection.attrs.backendId;
      }

      // Enable the tickets with which the user can get the current seat
      for(let ticket of this.ticketsTarget.querySelectorAll('.ticket-container')) {
        if(ticket.querySelector('.take-seat-button') == undefined) {
          continue;
        }

        let ticketCategory = ticket.dataset.seatCategoryId;

        if(ticketCategory == this.currentSelection.attrs.seatCategoryId) {
          ticket.querySelector('.take-seat-button').classList.remove('disabled');
        }
        else {
          ticket.querySelector('.take-seat-button').classList.add('disabled');
        }
      }

      return false;
    });
  }

  #disableAddButtons() {
    this.ticketsTarget.querySelectorAll('.ticket-container .take-seat-button').forEach((item) => {
      item.classList.add('disabled');
    });

    // Update the seatId in all selectedSeatInputs
    for(let input of this.ticketsTarget.querySelectorAll('input.selected-seat-input')) {
      input.value = null;
    }
  }

  #unselectSeat() {
    if(this.currentSelection) {
      this.currentSelection.setAttr('strokeWidth', 0);
      this.currentSelection = null;
    }

    for(let id of this.highlightedSeats) {
      let seat = this.seatsById[id];
      let seatColor = this.seatCategoryData[seat.attrs.seatCategoryId].color;
      seat.setAttr('fill', seatColor);
    }

    this.currentSelectedSeatInfoTarget.innerHTML = i18n._('Seatmap|Please select a seat');
  }

  #highlightSeats() {
    const urlParams = new URLSearchParams(window.location.search);
    const highlight = urlParams.getAll('highlight');
    this.highlightedSeats = [];

    if(highlight.length > 0) {
      for(let id of highlight) {
        this.highlightedSeats.push(id);
        this.seatsById[id]?.setAttr('fill', 'purple');
      }
    }
  }

  #updateSelectedSeatInfo() {
    let attributes = this.currentSelection.attrs;
    let categoryData = this.seatCategoryData[attributes.seatCategoryId];
    let infoString = '';

    infoString += `<span class="badge bg-secondary">${attributes.backendId}</span>`;
    infoString += `<span class="badge ms-2" style="background-color: ${categoryData.color}">${categoryData.name}</span><hr>`

    if(attributes.taken) {
      let username = attributes.userName;

      if(username) {
        infoString += `${i18n._('Seat|Seat is taken by')}: `;
        infoString += `<a href="/users/${attributes.userId}" target="_blank">${username}</a>`
      }
      else {
        infoString += i18n._('Seat|Seat is taken');
      }
    }
    else {
      infoString += i18n._('Seatmap|Seat is free');
    }

    this.currentSelectedSeatInfoTarget.innerHTML = infoString;
  }

  #toggleSidebar(e) {
    // Toggle the visibility of the sidebar and the size of the
    // main container.
    if(this.sidebarVisible) {
      this.sidebarTarget.classList.add('d-xl-none');
      this.mainColumnTarget.classList.add('w-100');
    }
    else {
      this.sidebarTarget.classList.remove('d-xl-none');
      this.mainColumnTarget.classList.remove('w-100');
    }

    // Toggle state
    this.sidebarVisible = !this.sidebarVisible;

    e.preventDefault();
    return false;
  }
}
