FastGettext.add_text_domain 'app', path: 'locale', type: :po, ignore_fuzzy: true, report_warning: false
FastGettext.default_available_locales = %w[en]
FastGettext.default_text_domain = 'app'
FastGettext.default_locale = 'en'
Rails.application.config.i18n.available_locales = FastGettext.default_available_locales
