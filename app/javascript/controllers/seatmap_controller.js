import { Controller } from "@hotwired/stimulus"
import 'konva'
import 'sweetalert2'

export default class extends Controller {
  static targets = ['container', 'contextMenu', 'dummyButton'];

  connect() {
    // Setup the base
    this.#setupBase();

    // Setup interactions
    this.#setupZoomFunctionality();
    this.#setupContextMenuFunctionality();

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
    }
  }

  // Setup the base of the seatmap
  #setupBase() {
    // Get the base data
    this.seatmapData = JSON.parse(this.containerTarget.dataset.seatmapData);

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

  #setupContextMenuFunctionality() {
    // Disable right click for now
    this.stage.on('contextmenu', e => {
      e.evt.preventDefault();

      if (e.target === this.stage || e.target === this.background) {
        // if we are on empty place of the stage we will do nothing
        return;
      }

      // show menu
      this.contextMenuTarget.style.display = 'initial';
      let containerRect = this.stage.container().getBoundingClientRect();
      this.contextMenuTarget.style.top = containerRect.top + this.stage.getPointerPosition().y + 4 + 'px';
      this.contextMenuTarget.style.left = containerRect.left + this.stage.getPointerPosition().x + 4 + 'px';
    });

    window.addEventListener('click', () => {
      // hide menu
      this.contextMenuTarget.style.display = 'none';
    });

    this.dummyButtonTarget.addEventListener('click', () => {
      console.log('hello');
    });
  }
}
