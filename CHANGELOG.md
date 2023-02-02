# Changelog

## 1.4.0 - UNRELEASED

### Added

* Add fine-grained permissions for tournaments
* Add views for disputed matches in admin panel
* Add some smaller quality of life features for tournament administration

### Changed

* Improve frontend styling of tournaments

### Fixed

* Fix some small bugs in ticket scanner

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