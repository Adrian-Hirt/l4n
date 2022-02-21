import { Controller } from "@hotwired/stimulus"
import 'konva'

export default class extends Controller {
  static targets = ['container'];

  connect() {
    // Setup the base
    this.#setupBase();

    // Setup interactions
    this.#setupZoomFunctionality();
    this.#setupSelectFunctionality();
  }

  addNewSeat(event) {
    // Skip the default event handlers
    event.preventDefault();

    // Create the new box. TODO: We'll need to finetune it a bit
    let newBox = new Konva.Rect({
      x: 50,
      y: 50,
      width: 100,
      height: 50,
      fill: '#00D2FF',
      draggable: true,
      name: 'seatRect'
    });

    // Add the new box
    this.baseLayer.add(newBox);

    // Add the seat to the array of seats
    this.seats.push(newBox);

    // And move the transformer to the top again
    this.transformer.moveToTop();

    return false;
  }

  saveSeatMap(event) {
    // Skip the default event handlers
    event.preventDefault();

    // Data to send to backend
    let postData = { seats: [] };

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
        backendId: seatData.backendId
      }
      postData.seats.push(dataToSend);
    }

    // Send the data

    return false;
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
    // Disable right click for now
    this.stage.on('contextmenu', e => {
      e.evt.preventDefault();
    });

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
}