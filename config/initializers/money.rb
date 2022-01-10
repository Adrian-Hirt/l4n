MoneyRails.configure do |config|
  # Set the default currency
  config.default_currency = :chf
  config.no_cents_if_whole = false

  # Handle the inclusion of validations for monetized fields
  config.include_validations = true

  # If you would like to use I18n localization (formatting depends on the
  # locale):
  config.locale_backend = :i18n
end
