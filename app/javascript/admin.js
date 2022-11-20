// Libraries
import "@hotwired/turbo-rails"

// Our components
import BootstrapTooltips from './components/bootstrap_tooltips'
import Translations from './components/translations'
import "@fortawesome/fontawesome-free/js/all"

FontAwesome.config.mutateApproach = 'sync'

// Our controllers
import "./controllers/admin.js"

document.addEventListener('turbo:load', function () {
  Translations.setup();
  BootstrapTooltips.setup();
});