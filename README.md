# Kuhsaft. A CMS as simple as it could be

**IMPORTANT: Kuhsaft >= 0.3.0 runs only on Rails 3.1. If you are stuck on
Rails 3 go for the 0.2 Versions**

Yiiihaaaaaa! Howdy, Let's milk the cow!

## The Who, What and Why?

Kuhsaft is made by some Rails developers at Screen Concept that got tired of
fiddling with unusable content management sytems. We are trying hard to make a
minimalistic and developer friendly CMS. Our goal is to provide a system for
ourselves and our customers that makes the of-the-shelf website project a
hasselfree thing. On one side easy to set up, integrate and customize (good for
devs) on the other hand it should be easily usable by anyone.

# Requirements

Kuhsaft requires

* A Rails 3 app to be integrated into
* ImageMagick
* An ActiveRecord compatible DB

# Installation

Add Kuhsaft to your Gemfile:

    gem 'kuhsaft'

And run

    bundle install

to get the gem

Then install the assets and the migrations and run them:

    rails generate kuhsaft:install:assets
    rails generate kuhsaft:install:migrations
    rake db:migrate
    
If you are upgrading, run those installers again and hopefully we will generate just the migrations you need.

(NOTE: Steps below should hopefully not be necessary in future versions:)

Finally, you need to add a before filter to the application controller (for now...)

    ApplicationController < ActionController::Base
      before_filter :available_locales

      def available_locales
        Kuhsaft::Page.translation_locales = ['de', 'en', 'fr']
      end
    end

If you want to use devise for protecting the admin parts, do this in an initializer:

    Kuhsaft::Cms::PagesController.class_eval do
      before_filter :authenticate_user!
    end

# Usage

## Building a navigation

Create a toplevel page and set the page type to "navigation". You can now get the child pages by using the navigation helper with the slug of that page: 

    navigation_for(:slug => 'main-navigation') { |pages| ... }

# LICENSE
  
See the file LICENSE.
