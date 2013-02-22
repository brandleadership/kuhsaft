## features/sortable_bricks

- make bricks sortable

## master
- disable/enable redirect_url field depending on page type dynamically
- show inactive state in page tree
- fix: require current rails version:
  - prevents vulnerable rails apps with kuhsaft
  - fixes issue where rake spec would run in development instead of test
    env.

- fix misterious case where the ajaxSuccess event sometimes was not
  triggered, leaving the textareas without readactor.js toolbar

## 1.1.1 - 2012-2-06
- Remove Kuhsaft::Cms::Admin seed
- Fix Migration

## 1.1.0 - 2013-02-06
- Remove devise from kuhsaft and provide instructions on how to protect the cms backend
- fix: properly handle compass-rails dependency

>>>>>>> fix/spec_failures_on_traivs

## 1.0.3 - 2013-02-04
- fix: fixed position regression introduced in 1.0.2
- fix: empty text brick doesn't fail

## 1.0.2 - 2013-02-04

- fix: brick position is properly incremented when created

## 1.0.1 - 2013-02-04

- bugfix: Add non-minified version of redactor.js ([@effkay][])

## 1.0.0 - 2013-02-04

### Major redesign
* added new brick system
* added new UI
* integrated with shoestrap

## 0.3.4 - January 27, 2012

- Add styles for 2 additional nesting levels in list views ([@effkay][])
- Refactor CSS into proper format ([@manufaktor][] & [@donaier][])
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
[@lindimelindi]: http://www.melinda-lini.de/
