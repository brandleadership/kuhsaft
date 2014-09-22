# CHANGELOG

## 2.5.1 - 2014-08-26

* Google Verification Key can be added on homepage and will be rendered in its head

## 2.5.0 - 2014-07-23

* Start merging in shoestrap functionality (for now, only admin_helper form methods)
* Clean up README
* Add helper for detecting if we are on a kuhsaft page
* Fix routing error for sitemap
* Add Helper for selecting Application URLs
* Set locale via default_url_options instead of just url_options
* Add CUSTOM page type:
  Adds a new page type called 'CUSTOM'. Custom pages behave almost like redirect pages except that they can have content and meta tags like normal pages.
  What can you use this for: To redirect to a custom controller that does whatever you want and still have CMS content along side it.

## 2.4.3 - 2014-07-10

* Fix inconsistent image size handling
* Fix jquery-ui load path on newer versions
* Clean up locales
* Misc refactorings

## 2.4.2 - 2014-05-19

* Bugfix: Check if column exists in translations migrations. Now you can always run the install:migrations tasks when updating kuhsaft in order to have all translated fields
          + various small bugfixes to translation migrations

## 2.4.1 - 2014-05-12

* Bugfix: Fix an issue where ck-config in host app would not get recompiled even though changes were made to it.

### HOWTO Upgrade

* Remove ck-config.js from your production.rb's precompile directive after updating kuhsaft to 2.4.1

## 2.4.0 - 2014-05-08

* Implement CKEditor Image Uploads. Disabled by default. See comments in ck-config for enabling it.

* Bugfixes:
  - consistent slug handling (is always downcased when saving)
  - update page tree urls for nested pages when changing page_type
  - Fix the issue where an old ck-config was being loaded due to the timestamp params ckeditor adds to
    it's asset urls

## 2.3.6 - 2014-05-01

* HOTFIX: Fix issues related to 2.3.4 release.
  - All brick js views are now .js.erb views for better readability
  - Wrap ruby calls in erb with html_safe

## 2.3.5 - 2014-04-30

* HOTFIX: Use .to_s.underscore when calling translated DB fields, so country specific locales work everywhere

## 2.3.4 - 2014-04-25

* HOTFIX: Handle non-escaped newline in create.js.haml view
  * Problem occurred only if there’s a ajax image upload combined with a text area. The remotipart JS is executed within a text area. Because of the newline the whole JS is broken.

## 2.3.3 - 2014-04-16

* added grid module

## 2.3.2 - 2014-04-02

* fixed/refactored new brick modals to fit smaller screens/bigger forms

## 2.3.1 - 2014-04-01

* New Module added that simplifies invalidating cached placeholder bricks when a non-kuhsaft model changes. Consult the readme for instructions!

## 2.3.0 - 2014-03-26

### HOWTO Upgrade

* `bundle update kuhsaft`
* `rake kuhsaft:install:migrations`
* `rake db:migrate`
* recreate versions for all bricks with uploaders:

  ```ruby
    # You need to do this for every locale you are using as bricks have a default_scope on the locale:
    I18n.with_locale(:de) { Kuhsaft::ImageBrick.all.each { |b| b.image.recreate_versions! if b.image.present? } }
    I18n.with_locale(:de) { Kuhsaft::AssetBrick.all.each { |b| b.asset.recreate_versions! if b.asset.present? } }
    I18n.with_locale(:de) { Kuhsaft::Asset.all.each  { |b| b.file.recreate_versions! if b.file.present? } }
  ```

* update your `config.assets.precompile` array with `ckeditor/adv_link/*` if you would
  like to use the new CK extension for internal links

* If you already have a customized ck-config just add ``config.extraAllowedContent = 'iframe[*]'`` to your ck-config.js.coffee
  if you would like to allow iframes in bricks with ck-editor

### Notable Changes

- It is now possible to link via dialogue to other CMS Pages within current locale
- Collapsable brick view
- Caching optimizations for pages and bricks
- Cleaned up brick validations: Save only valid Bricks and cleaned up brick forms
- Default value of page type field is now set to content
- add rake task which renames precompiled assets from ck-editor config to make
  sure that the newest config file is load in backend on staging and production
- add string length validation to prevent exceptions due to postgres string limit
- make migration for additional content languages be generated dynamic
- Translatable display styles
- Update display style dropdown
- add getter and setter for country specific translated pages
- Added `bundle exec rake db:seed` to setup rake task for easier development.
- allow iframes to be saved in ckeditor

## 2.2.6 - 2013-12-02

- Bump Rails dependency up to 4.0.2 due to multimple security issues

## 2.2.5 - 2013-12-02

- fix: make simple_form version constraint more future-proof

## 2.2.4 - 2013-12-02

- Update simple_form dependency due to XSS vulnerability:
  http://blog.plataformatec.com.br/2013/11/xss-vulnerability-on-simple-form/

## 2.2.3 - 2013-11-20

- fix bootstrap-sass issue by locking to newest compatible version
- Create module for kuhsaft image uploader

## 2.2.2 - 2013-10-10

- do not use inherited_resources
- correct order in classes for two column brick partitioning
- Dispaly error messages for bricks, when they are updated/saved

## 2.2.1 - 2013-10-02

- Add hints to input field of page settings

## 2.2.0 - 2013-10-02

- Extend meta tag definitions in `content_for :head` block

## 2.1.2 - 2013-09-25

- re-added inherited_resources
- explicitly tell simple_form to use the :bootstrap wrapper in forms
- upgrade to simple_form 3.0.0
- optimize method to set position of two_column_bricks, fixes inconsistent
  ordering

## 2.1.1 - 2013-09-03

- replaced ckeditor gem with ckeditor_rails gem
- temporarily removed 'inherited_resources'
- include page children in cache key for pages#show
- show "Inhalt"-Tab only when page is translated

  *run `rails generate kuhsaft:assets:install` when updating*

## 2.1.0 - 2013-08-21

- optimize seeds to be able to run multiple times
- add language-switch how-to to readme
- use inherited_resource
- remove deprecations
- add rake task to start dummy app
- document helper tasks
- fix dummy app loading
- add scope to select only translated pages
- Keep assets in cms subdir, not kuhsaft. Added a migration that
  should automatically move the assets.

  *run rake kuhsaft:install:migrations when updating*

## 1.8.6 - 2013-08-20

- Keep assets in cms subdir, not kuhsaft. Added a migration that
  should automatically move the assets.

  *run rake kuhsaft:install:migrations when updating*

## 2.0.3 / 1.8.5 - 2013-07-23

- Revert locale handling changes in 1.8.3
- Do not show invalid bricks in frontend

For 2.0.3 only:
  - remove attr_accessible calls, removes the need to
    use protected_attributes.
  - add page_title from 1.8.1

## 2.0.2 - 2013-07-22

- Fix styling bug in FF for sortable pages view

## 1.8.3 - 2013-07-18

- Redirect Handling: remove any preceding slashes first, then redirect to page link with one preceding front slash
- do not set locale through url_options in admin controller on every request
- page_title added
- Test Setup fixed

## 2.0.1 / 1.8.1 - 2013-07-16

- Fix redirect handling: remove any preceding slashes first
  then redirect to page link with one preceding front slash

- Bugfix: Explicitly require nestable css, fixes missing styling of pages index

## 2.0.0 - 2013-07-15

- Make Kuhsaft Rails 4 Compatible
  - replace compass with bourbon
  - use lambdas in scopes
  - use jquery-ui-rails and protected_attributes

**Kuhsaft >= 2.0.0 will only support Rails 4 and newer**

## 1.8.0 - 2013-07-15

- Implement nested sortable list: Pages can be reordered by drag and drop

## 1.7.1 - 2013-06-06

- remove validation on caption for accordion brick.
- add workaround for failing save of nested bricks due to after_save callback

## 1.7.0 - 2013-05-31

- Avoid routing error when editing a invalid page and change locale

- Postgres fulltext search
  - For details see README
  - Important: Please install and run the new migrations with `rake kuhsaft:install:migrations db:migrate`

## 1.6.0 - 2013-05-27

- Implement real redirect in pages_controller for redirect pages

## 1.5.0 - 2013-05-22

- Allow request with empty url splat to be handled by kuhsaft router
  - Allows root etries in host app: `root :to => 'kuhsaft/pages#show'`
  - No HomeConroller needed anymore
  - By default /:locale is handled by kuhsaft

## 1.4.3 - 2013-05-22

- bugfix: Define translated `find_by_<attr>_<locale>` methods on class

## 1.4.2 - 2013-05-14

- Fix page caching for localized pages by adding locale as cahe key

## 1.4.1 - 2013-03-05

- Correct file name of admin_helper.rb instead of application_helper.rb

## 1.4.0 - 2013-03-05

- Reorg Frontend Controller Inheritance:
  - Kuhsaft Frontend Controllers inherit from ApplicationController in the host application
  - Kuhsaft's own ApplicationController not needed anymore
  - **now you can use helpers defined in the guest application's ApplicationHelper on Kuhsaft Pages**

- Fix Locale Handling:
  - in Backend, always pass around content_locale param, to keep the correct locale set
  - remove before_validate callback: obsoleted because we pass locale around in params
  - use lambda for default scope as well, switch to new syntax for lambda

## features/settings_redirect_pages

- Do not show tab "Inhalt" when editing a redirect page

## 1.3.1 - 2013-04-12

- Replace redactor.js with CKEditor. To upgrade from previous versions:
  * run `rails generate kuhsaft:assets:install`
  * make sure you remove any code that references redactor, typically the editor settings in the customizations.js file

## 1.2.15 - 2013-04-09

- add column class to column brick

## 1.2.14 - 2013-04-02

- fix: add if-statements to asset and image bricks cause when a brick is created with no image or asset the page on proudction will crash
- fix: image Size is not applied when uploading an image in the image brick
- If you are upgrading, make sure to make following with all models which are using the ImageBrickImageUploader:
  * remove before_save callback and add after_save callback
  * add method image_present? to model an call it in the resize_image_if_size_changed-method as further if-statement

## 1.2.13 - 2013-03-25

- fix: solve the redactor.js problem a bit differently, should now always clear empty p tags from read more

## 1.2.12 - 2013-03-20

- add js function to remove empty read_more_text
- remove before_save hook in TextBrick model

## 1.2.11 - 2013-03-18

- updated readctor.js to 9.beta
- fix remove_cms_admins migration for pg: Check if table exist before dropping
- fix pg error by not using grouped scope on brick_type
- remove empty p-tags coming from readctor.js
- do not display read more link if no read_more_text is present

## 1.2.10 - 2013-03-08

- add checkbos on link Brick to trigger opening in new window/tab or not
- add Asset Brick for pdf's doc's and xls'

## 1.2.9 - 2013-03-06

- ditto... doh!

## 1.2.8 - 2013-03-06

- remove foo postfix for asset path generator... doh!

## 1.2.7 - 2013-03-06

- optimize/fix Brick UI dropdowns
- do not cache pages with placeholder bricks
- UI Tweak: read more link moves to bottom of collapsed content

## 1.2.6 - 2013-03-04

- change the way custom css and js is loaded. If you are upgrading, run
  `rails generate kuhsaft:assets:install` to get the override files.
  These files are now externally loaded and must be present!

## 1.2.5 - 2013-03-01

- optimize brick sorting with a single post to bricks_controller#sort
- add display_styles API to brick. implement `available_display_styles` on a brick to provide possible style classes
- UI Tweaks: page list is narrower, top-level row is not fluid anymore
- Disable remote form for Bricks with mounted uploader

## 1.2.4 - 2013-02-27
- actually downgrade jquery-rails dependency

## 1.2.3 - 2013-02-27
- Downgrade to jquery-rails 2.0.3 / jQuery 1.7.2
- Fix text brick partial for collapsable layout
- Implement necessary js files for collapsable content
- Add AnchorBrick
- Add visual feedback when saving a brick

## 1.2.2 - 2013-02-26
- migrate the brick types 'disabled' field to 'enabled'
- use mysql2 as the default driver in our tests

## 1.2.1 - 2013-02-26

- fix SQL dialect issue in brick type filter

## 1.2.0 - 2013-02-25

- set custom buttons on redactor editor
- add documentation which tags can be inserted by the editor and need styling
- added api to brick list to allow bricks to constrain their child bricks by type
- disable/enable redirect_url field depending on page type dynamically
- show inactive state in page tree
- fix: require current rails version:
  - prevents vulnerable rails apps with kuhsaft
  - fixes issue where rake spec would run in development instead of test
    env.
- fix misterious case where the ajaxSuccess event sometimes was not
  triggered, leaving the textareas without readactor.js toolbar
- make bricks sortable
- add success message when page is saved
- fix: Do not switch to content tab for page when there are validation errors in the meta tab

## 1.1.1 - 2013-02-06
- Remove Kuhsaft::Cms::Admin seed
- Fix Migration

## 1.1.0 - 2013-02-06
- Remove devise from kuhsaft and provide instructions on how to protect the cms backend
- fix: properly handle compass-rails dependency


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
