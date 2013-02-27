[![Build Status](https://api.travis-ci.org/screenconcept/kuhsaft.png)](http://travis-ci.org/screenconcept/kuhsaft)

# Kuhsaft. A CMS as simple as it could be

## The Who, What and Why?

Kuhsaft is made by some Rails developers at Screen Concept that got tired of
fiddling with unusable content management sytems. We are trying hard to make a
minimalistic and developer friendly CMS. Our goal is to provide a system for
ourselves and our customers that makes the of-the-shelf website project a
hasselfree thing. On one side easy to set up, integrate and customize (good for
devs) on the other hand it should be easily usable by anyone.

## What's in it

* A modular system to integrate any type of content structure
* Multilanguage content
* much more

# Requirements

Kuhsaft requires:

* A Rails 3.2 app to be integrated into
* ImageMagick
* An ActiveRecord compatible DB

# Installation

Add Kuhsaft to your Gemfile:

    gem 'kuhsaft'

And run

    bundle install

to get the gem

Then install the assets and the migrations and run them:

    rake kuhsaft:install:migrations
    rake db:migrate
    rake db:seed

You might want to change the language suffixes on the fields inside the create_kuhsaft_pages migration, depending on your app's default_locale.

Mount the kuhsaft engine in your routing file:

    MyApp::Application.routes.draw do
      # add your app routes here
      mount Kuhsaft::Engine => "/"
    end

Load the Kuhsaft assets into your app, so you have working grids, widgets etc:

    # application.css.sass
    @import 'kuhsaft/application'

    # application.js.coffee
    //= require 'kuhsaft/application'

## Authentication

Kuhsaft itself does not ship with any form of authentication. However, it is fairly easy to add by plugging into the Kuhsaft::Cms::AdminController. An example with devise:

```ruby
# config/initializers/kuhsaft.rb
Rails.application.config.to_prepare do
  Kuhsaft::Cms::AdminController.class_eval do
    before_filter :authenticate_user!
  end
end
```

Also, be sure to have override the navigation partial in `app/views/kuhsaft/cms/admin/_main_navigation.html.haml` so you get a working logout button.

## Modifying the backend CSS
Simply override the custom css in your app with your own style at `assets/stylesheets/kuhsaft/cms/customizations.css.sass`

## Modifying the backend javascript
Simply override the custom javascript in your app with your own script at `assets/javascripts/kuhsaft/cms/customizations.js.coffee`

## Testing

There's a dummy app inside spec/dummy. Get it running by executing the following steps:

* remove eventual migrations inside `spec/dummy/db/migrate`
* run `rake kuhsaft:install:migrations` again
* run `rake db:migrate` and `rake db:seed`

Start up the dummy app. The first two steps also make sure you're ready to run `rspec spec` to run the test suite. (Todo: This workflow must be improved))

# Usage

## Making Kuhsaft helpers available to your app

As defined in the rails docs, load the helpers from our isolated Kuhsaft engine inside your application controller:

    class ApplicationController < ActionController::Base
      helper Kuhsaft::Engine.helpers
    end

## Adding sublime video

Create an initializer file in your app inside `config/initializers` and set the `sublime_video_token`:

    Rails.application.config.to_prepare do
      Kuhsaft::Engine.configure do
        # Get the token from the MySites section on the sublime video site
        config.sublime_video_token = '123abcd'
      end
    end

Require the sublime javascript with the following helper:

    # in your application layout in the head section
    sublime_video_include_tag


## Configuring the image brick

The image brick can process uploaded images into specific sizes. These sizes can be configured inside the engine configuration. You can also use the built-in default sizes:

    # your_app/config/initializers/kuhsaft.rb
    Rails.application.config.to_prepare do
      Kuhsaft::Engine.configure do
        config.image_sizes.build_defaults! # creates 960x540 and 320x180 sizes
      end
    end

You can also remove the default sizes:

    # your_app/config/initializers/kuhsaft.rb
    Rails.application.config.to_prepare do
      Kuhsaft::Engine.configure do
        config.image_sizes.clear! # .all is now empty
      end
    end

And most importantly, you can add custom sizes:

    # your_app/config/initializers/kuhsaft.rb
    Rails.application.config.to_prepare do
      Kuhsaft::Engine.configure do
        config.image_sizes.add(:side_box_vertical, 180, 460)
        config.image_sizes.add(:footer_teaser, 320, 220)
      end
    end

The `name` option is a unique identifier, which is also used for translating the dropdown in the brick. You can add your translation by using the translation path:

    activerecord.attributes.kuhsaft/image_size.sizes.#{name}

## Configuring custom styles for bricks

Implement the `available_display_styles` on a brick model and return an array of css classnames: `['module-big', 'module-small']`. These styles can be applied to a brick instance through the UI.

## Adding custom templates with placeholder bricks

* Save your partial in `views/kuhsaft/placeholder_bricks/partials/_your_partial.html.haml`
* Add translations for your partial in `config/locales/models/kuhsaft/placeholder_brick/locale.yml`

```
de:
  your_partial: Your Partial
```

## Adding additional content languages

If you wan't to translate your pages into another language, generate a new translation migration:

    # translate your pages into french
    rails g kuhsaft:translations:add fr

This creates a new migration file inside `db/migrate` of your app. Run the migration as you normally do:

    rake db:migrate

Finally, add the new translation locale to your `available_locales` inside your apps `application.rb`:

    config.available_locales = [:en, :fr]

## Styling the content

By default, the text editor lets you add the following tags, for which you should supply some styles in your app:

    p, h1, h2, h3, ul, ol, table, a, strong, em

## Building a navigation

Building a navigation is simple, access to the page tree is available through the common methods built into the ancestry gem. Just make sure you are only accessing published pages for your production site, using the `published` scope.

### 2 level navigation example using simple-navigation

    SimpleNavigation::Configuration.run do |navigation|
      navigation.items do |primary|
        # build first level
        Kuhsaft::Page.roots.published.each do |page|
          primary.item page.id, page.title, page.link do |sub_item|
            # build second level
            page.children.published.each do |subpage|
              sub_item.item subpage.id, subpage.title, subpage.link
            end
          end
        end
      end
    end

## Modifying the backend navigation

Simply override the default partial for the main navigation in your app with your own file at `kuhsaft/cms/admin/_main_navigation.html.haml`

## Adding your own Bricks

* Create your Brick model in `app/models`, for example `CaptionBrick`, which inherits from `Kuhsaft::Brick`.
* Create a migration which adds the necessary fields to the `kuhsaft_bricks` table.
* If your brick should be accessible via UI, add a BrickType into the seeds or add a migration:
    `Kuhsaft::BrickType.create(:class_name => 'CaptionBrick', :group => 'elements')`
* Add the `edit` and `show` partials to your views, e.g: `app/views/caption_bricks/caption_brick/_edit.html.haml`
* Add the `childs` partial to your views, if you want to render your bricks childs with your own html: `app/views/caption_bricks/caption_brick/_childs.html.haml`
* Implement the `fulltext` method on your brick, return anything you want to be searchable.
* Customize the edit form behaviour of your brick by overriding methods like `to_style_class?`. See the `Brick` and `BrickList` files for more methods.

# LICENSE

See the file LICENSE.
