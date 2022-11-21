# Development notes

## Required env variables:

* `hcaptcha_site_key`
* `hcaptcha_site_secret`
* `steam_web_api_key`
* `discord_id`
* `discord_secret`
* `discord_bot_auth`

When using Paypal gateway:

* `paypal_id`
* `paypal_secret`

For the mailer gateway in production:

* `use_smtp`

If this is set to true (and the app uses smtp), we need the following
variables set as well:

* `mailer_host`
* `smtp_address`
* `smtp_port`
* `smtp_authentication`
* `smtp_username`
* `smtp_password`
* `smtp_domain`
* `smtp_enable_starttls`