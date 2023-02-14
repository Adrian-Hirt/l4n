# Development notes

## Required env variables:

### Rails-specific

* `SECRET_KEY_BASE`
* `AR_PRIMARY_KEY`
* `AR_DETERMINISTIC_KEY`
* `AR_KEY_DERIVATION_SALT`

General application:

* `APPLICATION_DOMAIN`

For the production database:

* `POSTGRES_HOSTNAME`
* `POSTGRES_PASSWORD`
* `POSTGRES_USER`

For the mailer gateway in production:

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

For the exception notification:

* `ENABLE_EXCEPTION_NOTIFIER`
* `EXCEPTION_NOTIFIER_RECIPIENT`

### Securing registration

* `RECAPTCHA_SITE_KEY`
* `RECAPTCHA_SITE_SECRET`

### Game accounts

* `STEAM_WEB_API_KEY`
* `DISCORD_ID`
* `DISCORD_SECRET`
* `DISCORD_BOT_AUTH`

### Payment gateways

When using Paypal gateway:

* `PAYPAL_ID`
* `PAYPAL_SECRET`
