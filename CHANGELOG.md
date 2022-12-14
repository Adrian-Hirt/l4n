# Changelog

## 1.0.1 - 2022-12-03

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