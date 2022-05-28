import { Controller } from "@hotwired/stimulus"
import 'konva'

export default class extends Controller {
  static targets = ['container', 'contextMenu', 'deleteButton', 'seatCategorySelector', 'seatQuantity'];

  connect() {
    // Setup the base
    this.#setupBase();

    // Setup interactions
    this.#setupZoomFunctionality();
    this.#setupSelectFunctionality();
    this.#setupContextMenuFunctionality();

    // Load seats from the data
    this.#loadSeats();
  }

  addNewSeat(event) {
    // Skip the default event handlers
    event.preventDefault();

    // We can only add a seat if we selected a seat category
    let seatCategoryId = this.seatCategorySelectorTarget.value;

    if(!seatCategoryId) {
      Sweetalert2.fire({
        title: i18n._('SeatMap|You need to select a seat category to add a seat!'),
        icon: 'error',
        confirmButtonText: i18n._('ConfirmDialog|Confirm')
      });

      return false;
    }

    let seatQuantity = this.seatQuantityTarget.value;

    // Check that we add at least 1 seat
    if (seatQuantity < 1) {
      Sweetalert2.fire({
        title: i18n._('SeatMap|You need to create at least 1 seat!'),
        icon: 'error',
        confirmButtonText: i18n._('ConfirmDialog|Confirm')
      });

      return false;
    }

    // Create the new seats. TODO: Put them somewhere they don'tm overlap with
    // already existing seats
    for(let i = 0; i < seatQuantity; i++) {
      let newSeat = new Konva.Rect({
        x: 50 * (i + 1),
        y: 50,
        width: 40,
        height: 40,
        fill: '#00D2FF',
        draggable: true,
        name: 'seatRect',
        seatCategoryId: parseInt(seatCategoryId)
      });
  
      // Add the new box
      this.baseLayer.add(newSeat);
  
      // Add the seat to the array of seats
      this.seats.push(newSeat);
    }

    // And move the transformer to the top again
    this.transformer.moveToTop();

    return false;
  }

  saveSeatMap(event) {
    // Skip the default event handlers
    event.preventDefault();

    // Data to send to backend
    let postData = {
      seats: [],
      removed_seats: this.removedSeats
    };

    // Pick the data we want to send
    for (let seat of this.seats) {
      let seatData = seat.getAttrs();
      let dataToSend = {
        x: seatData.x,
        y: seatData.y,
        height: seatData.height,
        width: seatData.width,
        rotation: seatData.rotation,
        scaleX: seatData.scaleX,
        scaleY: seatData.scaleY,
        backendId: seatData.backendId,
        seatCategoryId: seatData.seatCategoryId
      }
      postData.seats.push(dataToSend);
    }

    // Send the data
    const csrfToken = document.querySelector("[name='csrf-token']").content;

    let currentLocation = document.URL
    currentLocation = currentLocation.endsWith('/') ? currentLocation.slice(0, -1) : currentLocation;
    let url = `${currentLocation}/update_seats`;

    fetch(url, {
      method: "POST",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Content-Type": "application/json"
      },
      body: JSON.stringify(postData)
    }).then(response => {
      if(response.ok) {
        Sweetalert2.fire({
          title: i18n._('SeatMap|Saved successfully'),
          icon: 'success',
          confirmButtonText: i18n._('ConfirmDialog|Confirm')
        });
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

    return false;
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
        fill: '#00D2FF',
        draggable: true,
        name: 'seatRect',
        seatCategoryId: seat.seatCategoryId
      });

      // Add the new box
      this.baseLayer.add(newSeat);

      // Add the seat to the array of seats
      this.seats.push(newSeat);

      // And move the transformer to the top again
      this.transformer.moveToTop();
    }
  }

  // Setup the base of the seatmap
  #setupBase() {
    this.stage = new Konva.Stage({
      container: this.containerTarget,
      width: '1200',
      height: '500',
      draggable: false
    });

    // Add base layer
    this.baseLayer = new Konva.Layer();
    this.stage.add(this.baseLayer);

    // Add transformer
    this.transformer = new Konva.Transformer({
      keepRatio: false,
      flipEnabled: false,
      enabledAnchors: ['top-left', 'top-right', 'bottom-left', 'bottom-right'],
      rotateAnchorOffset: 20,
      rotationSnaps: [0, 90, 180, 270]
    });
    this.baseLayer.add(this.transformer);

    // Add some needed fields
    this.seats = [];
    this.removedSeats = [];
  }

  #setupZoomFunctionality() {
    let scaleBy = 1.1;

    this.stage.on('wheel', (e) => {
      // stop default scrolling
      e.evt.preventDefault();

      var oldScale = this.stage.scaleX();
      var pointer = this.stage.getPointerPosition();

      var mousePointTo = {
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

      var newScale = direction > 0 ? oldScale * scaleBy : oldScale / scaleBy;

      this.stage.scale({ x: newScale, y: newScale });

      var newPos = {
        x: pointer.x - mousePointTo.x * newScale,
        y: pointer.y - mousePointTo.y * newScale,
      };
      this.stage.position(newPos);
    });
  }

  #setupSelectFunctionality() {
    // Add the selection rectangle
    this.selectionRectangle = new Konva.Rect({
      fill: 'rgba(0,0,255,0.5)',
      visible: false
    });

    this.baseLayer.add(this.selectionRectangle);

    // Add watcher for the mousedown event, as we want to be able
    // to select a range of elements by clicking & dragging with
    // the right mouse button
    this.stage.on('mousedown', (e) => {
      // do nothing if we mousedown on any shape
      if (e.target !== this.stage) {
        return;
      }

      const isLeft = e.evt.button === 0;
      this.stage.draggable(isLeft);

      // If we clicked with left, do nothing, as left click is
      // for interacting with the shapes and the canvas itself
      if(isLeft) {
        return;
      }

      // Skip the default event handlers
      e.evt.preventDefault();

      // Get x, y position of mouse
      this.startX = this.stage.getRelativePointerPosition().x;
      this.startY = this.stage.getRelativePointerPosition().y;

      // Show the selection rectangle
      this.selectionRectangle.visible(true);
      this.selectionRectangle.width(0);
      this.selectionRectangle.height(0);
    });

    // Add watcher for the mousemove event, as we want to be able
    // to select a range of elements by clicking & dragging with
    // the right mouse button
    this.stage.on('mousemove', (e) => {
      // do nothing if we didn't start selection
      if (!this.selectionRectangle.visible()) {
        return;
      }

      // Skip the default event handlers
      e.evt.preventDefault();

      // Get x, y position of mouse
      this.currentX = this.stage.getRelativePointerPosition().x;
      this.currentY = this.stage.getRelativePointerPosition().y;

      // Update the selection rectangle
      this.selectionRectangle.setAttrs({
        x: Math.min(this.startX, this.currentX),
        y: Math.min(this.startY, this.currentY),
        width: Math.abs(this.currentX - this.startX),
        height: Math.abs(this.currentY - this.startY),
      });
    });

    // Add watcher for the mouseup event
    this.stage.on('mouseup', (e) => {
      // do nothing if we didn't start selection
      if (!this.selectionRectangle.visible()) {
        return;
      }

      // Skip the default event handlers
      e.evt.preventDefault();

      // update visibility in timeout, so we can check it in click event
      setTimeout(() => {
        this.selectionRectangle.visible(false);
      });

      // Get all rectangles that intersect with the selection box
      let shapes = this.stage.find('.seatRect');
      let box = this.selectionRectangle.getClientRect();
      let selected = shapes.filter((shape) =>
        Konva.Util.haveIntersection(box, shape.getClientRect())
      );

      // For correct look of the transformer
      this.transformer.moveToTop();

      // Add the selected nodes to the transformer
      this.transformer.nodes(selected);
    });

    // clicks should select/deselect shapes
    this.stage.on('click', (e) => {
      // if we are selecting with rect, do nothing
      if (this.selectionRectangle.visible()) {
        return;
      }

      // if click on empty area - remove all selections
      if (e.target === this.stage) {
        this.transformer.nodes([]);
        return;
      }

      // do nothing if clicked NOT on our rectangles
      if (!e.target.hasName('seatRect')) {
        return;
      }

      // do we pressed shift or ctrl?
      const metaPressed = e.evt.shiftKey || e.evt.ctrlKey || e.evt.metaKey;
      const isSelected = this.transformer.nodes().indexOf(e.target) >= 0;

      if (!metaPressed && !isSelected) {
        // if no key pressed and the node is not selected
        // select just one
        this.transformer.nodes([e.target]);
      }
      else if (metaPressed && isSelected) {
        // if we pressed keys and node was selected
        // we need to remove it from selection:
        const nodes = this.transformer.nodes().slice(); // use slice to have new copy of array
        // remove node from array
        nodes.splice(nodes.indexOf(e.target), 1);
        this.transformer.nodes(nodes);
      }
      else if (metaPressed && !isSelected) {
        // add the node into selection
        const nodes = this.transformer.nodes().concat([e.target]);
        this.transformer.nodes(nodes);
      }
    });
  }

  #setupContextMenuFunctionality() {
    // Disable right click for now
    this.stage.on('contextmenu', e => {
      e.evt.preventDefault();

      if (e.target === this.stage) {
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

    this.deleteButtonTarget.addEventListener('click', () => {
      this.seats = this.seats.filter(seat => !this.transformer.nodes().includes(seat));

      for (let node of this.transformer.nodes()) {
        if (node.attrs.backendId) {
          this.removedSeats.push(node.attrs.backendId);
        }

        node.destroy();
      }

      this.transformer.nodes([]);
    });
  }
}