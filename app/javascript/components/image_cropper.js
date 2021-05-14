import Cropper from 'cropperjs';

export default class ImageCropper {
  constructor(container) {
    this.container = container;
    this.canvas = container.find('canvas').get(0);
    this.imageLoader = container.find('#imageLoader').get(0);
    this.ctx = this.canvas.getContext('2d');
    this.cropper = new Cropper(this.canvas, {aspectRatio: 1/1, preview: '.cropperPreview'});
    this.uploadButton = container.find('#cropperUploadButton');

    this.canvas.addEventListener('ready', function () {
      this.cropper.setCropBoxData({
        "left":0,
        "top":0,
        "width":300,
        "height":300
      });
    });

    this.imageLoader.addEventListener('change', (e) => {
      console.log(this);
      var reader = new FileReader();
      reader.onload = (event) => {
        console.log(this);
        var img = new Image();
        img.src = event.target.result;
        this.cropper.replace(img.src);
      }
      reader.readAsDataURL(e.target.files[0]);
    });

    this.uploadButton.on('click', () => {
      this.uploadImageToUrl();
    });

    var initialUrl = $(this.canvas).attr('data-initial');

    if (initialUrl != null) {
      this.loadInitialImage(initialUrl);
    }
  }

  loadInitialImage(initialImageUrl) {
    var img = new Image;
    img.width = this.canvas.width;
    img.height = this.canvas.height;
    img.onload = (e) => this.ctx.drawImage(e.target, 0, 0, 300, 300);

    var src = initialImageUrl.replace(/^url|["()]/g, "");
    var reader = new FileReader;
    reader.onload = (e) => {
      img.src = e.target.result;
      this.cropper.replace(img.src);
    }
    fetch(src)
    .then(response => response.blob())
    .then(blob => {
      reader.readAsDataURL(blob);
    });
  }

  uploadImageToUrl() {
    let submitUrl = this.uploadButton.attr('data-url');

    this.cropper.getCroppedCanvas().toBlob((blob) => {
      let formData = new FormData();

      formData.append('croppedImage', blob);

      $.ajax(submitUrl, {
        method: 'PATCH',
        data: formData,
        processData: false,
        contentType: false,
        success() {
          console.log('Upload success');
          Turbolinks.visit(window.location);
        },
        error() {
          console.log('Upload error');
        },
      });
    });
  }
}
