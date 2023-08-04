# Development notes

## Required env variables:

### Rails-specific

* `SECRET_KEY_BASE`
* `AR_PRIMARY_KEY`
* `AR_DETERMINISTIC_KEY`
* `AR_KEY_DERIVATION_SALT`

General application:

* `APPLICATION_DOMAIN`

OpenID connect:

* `OIDC_RSA_PRIVATE_KEY` should contain a valid RSA private key to sign the JSON web signature

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
* `EXCEPTION_NOTIFIER_SENDER` (optional)

For the devise mailer

* `DEVISE_MAIL_SENDER` (optional)

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


## Use remote form modal

L4N features a remote form modal, which enables to create / update data without having to navigate to a new page.

The feature is used as follows:

**Link to open the modal**:

```ruby
= link_to "New item", new_item_path, class: "btn btn-primary", data: { turbo_frame: "remote_modal" }
```

**Controller**:

```ruby
def new
  @item = NewsPost.new

  show_turbo_modal modal_title: 'New Item', partial: 'form', partial_locals: { item: @item }
end

def create
  @item = NewsPost.new(params[:news_post].permit(:title))

  if @item.save
    redirect_to root_path, notice: "Item was successfully created."
  else
    update_turbo_modal partial: 'form', partial_locals: { item: @item }
  end
end
```

**Form partial**:

Contains only the content to be rendered in the modal!

```ruby
= simple_form_for item , url: items_path do |f|
  = f.input :title
  = f.save
```