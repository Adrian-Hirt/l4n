import { Controller } from '@hotwired/stimulus';
import Cropper from 'cropperjs';
import Sweetalert2 from 'sweetalert2';
import Translations from '../components/translations';

export default class extends Controller {
  static targets = ['imageLoader', 'uploadButton', 'canvas', 'fileNameList'];

  connect() {
    this.canvas = this.canvasTarget;
    this.imageLoader = this.imageLoaderTarget;
    this.ctx = this.canvas.getContext('2d');
    this.cropper = new Cropper(this.canvas, {aspectRatio: 1/1, preview: '.cropper-preview'});

    this.canvas.addEventListener('ready', function () {
      this.cropper.setCropBoxData({
        'left':0,
        'top':0,
        'width':300,
        'height':300
      });
    });

    this.imageLoader.addEventListener('change', (e) => {
      var reader = new FileReader();
      reader.onload = (event) => {
        var img = new Image();
        img.src = event.target.result;
        this.cropper.replace(img.src);
      };
      reader.readAsDataURL(e.target.files[0]);

      let fileName = this.imageLoader.files[0].name;
      this.fileNameListTarget.innerHTML = fileName;
      this.uploadButtonTarget.classList.remove('disabled');
    });

    var initialUrl = this.canvas.getAttribute('data-initial');

    if (initialUrl != null) {
      this._loadInitialImage(initialUrl);
    }
  }

  uploadImage(event) {
    event.preventDefault();
    let submitUrl = this.uploadButtonTarget.getAttribute('data-url');
    let csrfToken = document.querySelector('[name=\'csrf-token\']').content;

    this.cropper.getCroppedCanvas().toBlob((blob) => {
      let formData = new FormData();
      formData.append('croppedImage', blob);

      fetch(submitUrl, {
        method: 'PATCH',
        headers: {
          'X-CSRF-Token': csrfToken
        },
        body: formData
      })
        .then((response) => {
          if(response.status === 200) {
            window.Turbo.visit(window.location);
          }
          else {
            Sweetalert2.fire({
              title: Translations._('Avatar|Uploading avatar failed'),
              icon: 'error',
              cancelButtonText: Translations._('ConfirmDialog|Confirm'),
              showConfirmButton: false,
              showCancelButton: true
            });
          }
        });
    });

    return false;
  }

  _loadInitialImage(initialImageUrl) {
    var img = new Image;
    img.width = this.canvas.width;
    img.height = this.canvas.height;
    img.onload = (e) => this.ctx.drawImage(e.target, 0, 0, 300, 300);

    var src = initialImageUrl.replace(/^url|["()]/g, '');
    var reader = new FileReader;
    reader.onload = (e) => {
      img.src = e.target.result;
      this.cropper.replace(img.src);
    };
    fetch(src)
      .then(response => response.blob())
      .then(blob => {
        reader.readAsDataURL(blob);
      });
  }
}
