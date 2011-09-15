## master

### Bug fixes

### Improvements

### New features

## 0.3.2 - September 15, 2011

*Development of Kuhsaft for Rails 3.1 moved to master, rails30 will
maintain rails 3.0 compatibility*

### Bug fixes

- fix asset pipeline compatibility when in production ([@effkay][])

### Improvements

- fix README on how to integrate devise ([@effkay][])


## 0.2.5 - August 29, 2011

### Bug fixes

- fix a bug where virtual page tree wasn't available ([@manufaktor][])

## 0.2.4 - August 29, 2011

### Improvements

- handle 404s with an ActionController::RoutingError, controllers can optionally implement a `handle_404` method to change behavior ([@manufaktor][])
- Backend now shows the hierarchy breadcrumb when creating a new page ([@manufaktor][])

## 0.2.3 - August 19, 2011

### Bug fixes

- update gem versions of dependencies, because some contain bugfixes (linecache, carrierwave) ([@manufaktor][])

## 0.3.1 - August 9, 2011

### Bug fixes

- fix image paths and update readme concerning asset pipeline ([@effkay][])

### Improvements

- we have a changelog now! ([@effkay][])

### New features

## 0.3.0 - August 8, 2011

### Improvements

- moved assets to a rails 3.1 compatible location ([@effkay][])

## 0.2.2 - August 5, 2011

### Bug fixes

- `params[:locale]` is now recognized by the PagesController ([@manufaktor][])

### Improvements

- Lots of styling improvements for the backend ([@iphilgood][] & [melinda][])
- Formatted Text textareas now resize smartly according to its content ([@iphilgood][] & [melinda][])
- Added specific delete messages for pages and assets ([@manufaktor][])
- Updated to latest UJS Jquery ([@manufaktor][])
- Backend recognizes a current_user and will display a logout possibility ([@iphilgood][])

[@manufaktor]: https://github.com/manufaktor
[@effkay]: https://github.com/effkay
[@iphilgood]: https://github.com/iphilgood
[@tscholz]: https://github.com/tscholz
[melinda]: http://www.melinda-lini.de/
