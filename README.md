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

# Usage

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

# LICENSE

See the file LICENSE.
