// Libraries
import '@hotwired/turbo-rails';
import { Application } from '@hotwired/stimulus';
import { Autocomplete } from 'stimulus-autocomplete';

// Our components
import BootstrapTooltips from './components/bootstrap_tooltips';
import Translations from './components/translations';
import '@fortawesome/fontawesome-free/js/all';

// Font awesome needs this to work properly with turbo
window.FontAwesome.config.mutateApproach = 'sync';

// Setup our translations
Translations.setup();

// Register the Autocomplete controller
const application = Application.start();
application.register('autocomplete', Autocomplete);

// Import our controllers
import './controllers/index.js';

document.addEventListener('turbo:load', function () {
  BootstrapTooltips.setup();
});