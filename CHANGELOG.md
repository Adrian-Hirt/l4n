# Changelog

## 1.9.3 - 2023-09-21

### Fixed

* Fix a logic bug in the User model

## 1.9.2 - 2023-09-06

### Fixed

* Fixed two minor bugs in the shop

## 1.9.1 - 2023-08-24

### Fixed

* Fix a bug preventing users to be deleted
* Fix color theme in login view

### Changed

* Updates gems to fix CVEs

## 1.9.0 - 2023-08-13

### Added

* Added filters for uploads in admin panel
* Force SSL in production mode
* Allow changing category of ticket to a category without a product
* Allow configuring the sender for exception notifications & devise
  mails via env variables
* Add light and dark color modes to frontend

### Changed

* Allow users to be deleted by admins
* Allow users to delete their own account
* Require OTP code to deactivate 2FA on an account
* Update gem dependencies
* Update bootstrap to `5.3.0`

## 1.8.1 - 2023-05-21

### Added

* Added missing translations for new features from `1.8.0`

## 1.8.0 - 2023-05-21

### Changed

* Update ruby to `3.2.2` and enable YJIT
* Update gem dependencies
* Payment & Payment Assist: Check if item is on sale before running process
* Reduce stored sensitive data
  + Remove saved addresses on User model
  + Only request address for order if any product behaviour requires it
  + Delete address on order on completion of order
* Migrate permissions on user to more fine-grained system

### Added

* Add script to create the first admin user after a fresh install

## 1.7.2 - 2023-04-09

### Changed

* Add nonce to oauth post form

## 1.7.1 - 2023-04-06

### Fixed

* Fix exception in shop when purchasing ticket upgrade
  where the `to_category` is not available anymore

### Added

* Various quality of usage improvements for tournament admin view
* Add filters to ticket list in admin panel

### Changed

* Updated dependencies to fix CVEs

## 1.7.0 - 2023-03-12

### Added

* Added `/api/v1/lan_parties/me` API endpoint

### Changed

* Update `rack` gem

## 1.6.9 - 2023-03-06

### Fixed

* Fix exception in the tickets view

## 1.6.8 - 2023-03-06

### Fixed

* Fix a bug in the shop home view

## 1.6.7 - 2023-03-06

### Added

* Add ability to assign multiple tickets to an user

## 1.6.6 - 2023-03-03

### Added

* Add `show_availability` toggler for Product

## 1.6.5 - 2023-03-03

### Added

* Seperate products in shop by category

## 1.6.4 - 2023-03-01

### Added

* Add `username` to OIDC ID token
* Add warning banner to seatmap when user has unassigned tickets

### Fixed

* Fixed various bugs with the tournament system
* Fix redirect page not working properly

## 1.6.3 - 2023-02-17

### Fixed

* Fix another bug with the tournaments view

## 1.6.2 - 2023-02-17

### Fixed

* Fix a bug where users would not see any tournaments in the frontend

## 1.6.1 - 2023-02-16

### Fixed

* Fix a bug in the ability that would show the tournament index to anyone
  having any admin permissions (without showing any torunaments)

## 1.6.0 - 2023-02-14

### Added

* Added OpenID connect functions

* Added new env variable `OIDC_RSA_PRIVATE_KEY` to `docker-compose.yml`
  template

### Changed

* Renamed env variable `HOST_DOMAIN` to `APPLICATION_DOMAIN` which
  must be a valid url, without the protocol and without trailing slash.

### Upgrading instructions

* Replace all occurences of `HOST_DOMAIN` with `APPLICATION_DOMAIN` in
  your `.env` file and the `docker-compose.yml` file (see the
  `docker-compose.yml` in this repo for how it should look).

* Add the following two lines to your `environment` block of the
  `docker-compose.yml` file:

  ```yaml
  # RSA private key for OIDC
  OIDC_RSA_PRIVATE_KEY: ${OIDC_RSA_PRIVATE_KEY:?err}
  ```

  Also, set the value of the `OIDC_RSA_PRIVATE_KEY` env variable
  (preferrably in the `.env` file) to a valid private RSA key
  for signing the JWTs generated from the OpenID connect endpoint

## 1.5.0 - 2023-02-08

### Changed

* Add possibility to have multiple lan parties active at the same time
* Update gem dependencies

## 1.4.1 - 2023-02-05

### Changed

* Add error pages for status `405` and `406`
* Add some user-error exceptions to the ignore list of the exception notifier

## 1.4.0 - 2023-02-02

### Added

* Add fine-grained permissions for tournaments
* Add views for disputed matches in admin panel
* Add some smaller quality of life features for tournament administration

### Changed

* Improve frontend styling of tournaments

### Fixed

* Fix some small bugs in ticket scanner

## 1.3.4 - 2023-01-23

### Changed

* Update translations

## 1.3.3 - 2023-01-22

### Fixed

* Update `Rails` and `Rack` to resolve CVEs
* Fix minor bugs reported by Exception Notifier

## 1.3.2 - 2023-01-15

### Changed

* Add ability to manually create tickets for all categories
* Improve styling of sidebar in seatmap view

## 1.3.1 - 2023-01-12

### Fixed

* Fixed exception in mailer config
* Fixed exception notifications for BadRequest exceptions

### Added

* Added some missing translations

### Changed

* Make sidebar sticky in seatmap on non-mobile

## 1.3.0 - 2023-01-02

### Fixed

* Fixed a bug with uploads not working properly due to the use of UUID as the primary key.
  When upgrading, please check that your uploads still work properly

### Added

* Add ability to set the favicon of the app in the `Settings` tab

## 1.2.0 - 2022-12-29

### Added

* Add OAuth provider
* Add new API endpoint to fetch details for an user at a LanParty
* Add new `DeveloperAdmin` permission
* Add icons to username dropdown in application header
* Add feature flag for API & OAuth
* Display changelog in Admin Panel

### Fixed

* Add missing margins to cards on mobile

### Changed

* Update gem dependencies

## 1.1.3 - 2022-12-26

### Fixed

* Fix flashes shown twice
* Fix incorrect tickets shown in manage view

## 1.1.2 - 2022-12-25

### Fixed

* Fix a nil exception when opening a past event
* Fix exception when adding team without rank in admin panel
* Fix wrong order of events in event archive grid

## 1.1.1 - 2022-12-19

### Fixed

* Fixed a nil exception in Events Archive grid

## 1.1.0 - 2022-12-19

### Added

* Add autocomplete to ticket assigigning
* Display hint when no events available in events list

### Changed

* Moved `location` from `Event` to `EventDate` model
* Move assigning of tickets to manage view from seatmap
* Add filtering of shop by categories
* Allow dots and slashes in page URL
* Disable password autofill in registration and update profile form
* Improve styling of markdown rendering
* Order events in archive by date descending
* Use `db:prepare` in `docker-compose.yml` instead of `db:migrate`

## 1.0.3 - 2022-12-16

### Fixed

* Implement updating of `total_inventory`
* Fix markdown editor duplicating

## 1.0.2 - 2022-12-14

### Fixed

* Fix changelog date
* Fix L4N Version

## 1.0.1 - 2022-12-14

### Added

* Add `total_inventory` to `Product` for bookkeeping
* Start cron service on startup of docker compose

### Changed

* LanParty progressbar now uses `total_inventory` for calculation

### Fixed

* Update gem dependencies to resolve CVEs
* Fix missing translation in header dropdown
* Fix exception in Uploads view
* Fix payment gateway being shown too early
* Fix `whenever` schedule

## 1.0.0 - 2022-12-03

* First major release

## 0.1.1 - 2022-12-03

* Add new action to tag images when pushing a tag

## 0.1.0 - 2022-12-03

* Initial, first tagged release to test docker build with tagged commits