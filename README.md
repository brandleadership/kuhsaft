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

    Kuhsaft::Engine.configure do
      # Get the token from the MySites section on the sublime video site
      config.sublime_video_token = '123abcd'
    end

Require the sublime javascript with the following helper:

    # in your application layout in the head section
    sublime_video_include_tag


## Adding additional content languages

If you wan't to translate your pages into another language, generate a new translation migration:

    # translate your pages into french
    rails g kuhsaft:translations:add fr

This creates a new migration file inside `db/migrate` of your app. Run the migration as you normally do:

    rake db:migrate

Finally, add the new translation locale to your `available_locales` inside your apps `application.rb`:

    config.available_locales = [:en, :fr]

## Building a navigation

todo

## Adding your own Bricks

* Create your Brick model in `app/models`, for example `CaptionBrick`, which inherits from `Kuhsaft::Brick`.
* Create a migration which adds the necessary fields to the `kuhsaft_bricks` table.
* If your brick should be accessible via UI, add a BrickType into the seeds or add a migration:
    `Kuhsaft::BrickType.create(:class_name => 'CaptionBrick', :group => 'elements')`
* Add the `edit` and `show` partials to your views, e.g: `app/views/caption_bricks/caption_brick/_edit.html.haml`
* Add the `childs` partial to your views, if you want to render your bricks childs with your own html: `app/views/caption_bricks/caption_brick/_childs.html.haml`
* Implement the `fulltext` method on your brick, return anything you want to be searchable.
* Customize the edit form behaviour of your brick by overriding methods like `render_as_horizontal_form?`. See the `Brick` and `BrickList` files for more methods.

# LICENSE

See the file LICENSE.
