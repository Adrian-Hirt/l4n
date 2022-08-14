# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/javascript/components', under: 'components'
pin_all_from 'app/javascript/utils', under: 'utils'
pin 'bootstrap' # @5.1.0
pin '@popperjs/core', to: 'popperjs.min.js' # @2.11.0
pin '@fortawesome/fontawesome-free', to: 'fontawesome-free-all.min.js' # @6.1.2
pin 'gettext.js' # @1.1.1
pin 'easymde', to: 'easymde.min.js' # @2.15.0
pin 'sweetalert2' # @11.3.0
pin 'cropperjs', to: 'cropper.esm.js'
pin 'konva', to: 'konva.min.js'
