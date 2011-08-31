## master / rails31

### Bug fixes

- fix a bug where virtual page tree wasn't available ([@manufaktor][])

### Improvements

- fix README on how to integrate devise (rails31) ([@effkay][])
- handle 404s with an ActionController::RoutingError, controllers can optionally implement a `handle_404` method to change behavior ([@manufaktor][])
- Backend now shows the hierarchy breadcrumb when creating a new page ([@manufaktor][])
- update gem versions of dependencies, because some contain bugfixes (linecache, carrierwave) ([@manufaktor][])

### New features

## 0.3.1 - August 9, 2011

### Bug fixes

- fix image paths and update readme concerning asset pipeline ([@effkay][])

### Improvements

- we have a changelog now! ([@effkay][])

## 0.3.0 - August 8, 2011

### Improvements

- moved assets to a rails 3.1 compatible location. ([@effkay][])

[@manufaktor]: https://github.com/manufaktor
[@effkay]: https://github.com/effkay
[@iphilgood]: https://github.com/iphilgood
[melinda]: http://www.melinda-lini.de/
