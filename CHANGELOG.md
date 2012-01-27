## master

## 0.3.4 - January 27, 2012

- Add styles for 2 additional nesting levels in list views ([@effkay][])
- Refactor CSS into proper format ([@manufaktor][] & [@donaier])
- Migrate JS to asset pipeline/sprockets ([@effkay][])

## 0.3.3 - November 10, 2011

- Add german locale file for backend ([@jenzer][])

## 0.3.2 - September 15, 2011

**Development of Kuhsaft for Rails 3.1 moved to master, rails30 will
maintain rails 3.0 compatibility**

- fix asset pipeline compatibility when in production ([@effkay][])
- fix README on how to integrate devise ([@effkay][])

## 0.2.5 - August 29, 2011

- fix a bug where virtual page tree wasn't available ([@manufaktor][])

## 0.2.4 - August 29, 2011

- handle 404s with an ActionController::RoutingError, controllers can optionally implement a `handle_404` method to change behavior ([@manufaktor][])
- Backend now shows the hierarchy breadcrumb when creating a new page ([@manufaktor][])

## 0.2.3 - August 19, 2011

- update gem versions of dependencies, because some contain bugfixes (linecache, carrierwave) ([@manufaktor][])

## 0.3.1 - August 9, 2011

- fix image paths and update readme concerning asset pipeline ([@effkay][])
- we have a changelog now! ([@effkay][])

## 0.3.0 - August 8, 2011

- moved assets to a rails 3.1 compatible location ([@effkay][])

## 0.2.2 - August 5, 2011

- `params[:locale]` is now recognized by the PagesController ([@manufaktor][])
- Lots of styling improvements for the backend ([@iphilgood][] & [melinda][])
- Formatted Text textareas now resize smartly according to its content ([@iphilgood][] & [melinda][])
- Added specific delete messages for pages and assets ([@manufaktor][])
- Updated to latest UJS Jquery ([@manufaktor][])
- Backend recognizes a current_user and will display a logout possibility ([@iphilgood][])

[@manufaktor]: https://github.com/manufaktor
[@donaier]: https://github.com/donaier
[@effkay]: https://github.com/effkay
[@iphilgood]: https://github.com/iphilgood
[@tscholz]: https://github.com/tscholz
[@jenzer]: https://github.com/jenzer
[melinda]: http://www.melinda-lini.de/
