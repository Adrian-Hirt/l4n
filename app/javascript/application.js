// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@popperjs/core"
import * as bootstrap from "bootstrap"
import '@fortawesome/fontawesome-free'
import Translations from 'components/translations'
import BootstrapTooltips from 'components/bootstrap_tooltips'

// https://fontawesome.com/v5.15/how-to-use/on-the-web/using-with/turbolinks
FontAwesome.config.mutateApproach = 'sync'

Translations.setup();
BootstrapTooltips.setup();

window.bootstrap = bootstrap;