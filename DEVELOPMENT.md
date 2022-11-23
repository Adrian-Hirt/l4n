# Development notes

## Required env variables:

### Rails-specific

* `SECRET_KEY_BASE`
* `AR_PRIMARY_KEY`
* `AR_DETERMINISTIC_KEY`
* `AR_KEY_DERIVATION_SALT`

For the mailer gateway in production:

* `HOST_DOMAIN`
* `USE_SMTP`

If `USE_SMTP` is set to true (and the app uses smtp), we need the following
variables set as well:

* `SMTP_ADDRESS`
* `SMTP_PORT`
* `SMTP_AUTHENTICATION`
* `SMTP_USERNAME`
* `SMTP_PASSWORD`
* `SMTP_DOMAIN`
* `SMTP_ENABLE_STARTTLS`

### Securing registration

* `HCAPTCHA_SITE_KEY`
* `HCAPTCHA_SITE_SECRET`

### Game accounts

* `STEAM_WEB_API_KEY`
* `DISCORD_ID`
* `DISCORD_SECRET`
* `DISCORD_BOT_AUTH`

### Payment gateways

When using Paypal gateway:

* `PAYPAL_ID`
* `PAYPAL_SECRET`
