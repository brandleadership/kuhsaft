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

## Adding additional content languages

If you wan't to translate your pages into another language, generate a new translation migration:

    # translate your pages into french
    rails g kuhsaft:translations:add fr

This creates a new migration file inside `db/migrate` of your app. Run the migration as you normally do:

    rake db:migrate

Finally, add the new translation locale to your `available_locales` inside your apps `application.rb`:

    config.available_locales = [:en, :fr]

## Building a navigation

Create a toplevel page and set the page type to "navigation". You can now get the child pages by using the navigation helper with the slug of that page:

    navigation_for(:slug => 'main-navigation') { |pages| ... }


## Integrating custom Models into Kuhsaft (aka Rails Admin Lite)

There is a chance that Pages and Assets is not enough for you and you
need custom models in your Rails app. It's your lucky day, because
Kuhsaft was designed with the goal to easily integrate into a usual
 Rails app.

There is one caveat though: You need to **stay in the Kuhsaft namespaces
for your admin controllers and views** if you want to use the Kuhsaft UI
as a backend to your models.

There is a high probability that we will ship our own generators for all
this stuff in the future, meanwhile, you'll have to do some manual work:

Add the route to your resource, within the locale scope and the cms
namespace:

```ruby
scope ':locale' do
  namespace :cms do
    resources :projects
  end
end
```

Put your admin controller for the model in question in
`app/controllers/cms/` and keep it in the `Cms` namespace, e.g:

```ruby
module Cms
  class ProjectsController < Kuhsaft::Cms::AdminController
    def index
      # do somethinng
    end
  end
end
```

As you can see you have to inherit from `Kuhsaft::Cms::AdminController`

As with the controllers, you have to respect the namespaces when adding
the view. For the example above, we would create an index view in
`app/views/cms/projects/`

As an example, the view might look something like this:

```ruby
- content_for :admin_toolbar do
  = link_to t('.create'), new_cms_project_path, :class => 'button'

- content_for :cms_language_tabs do
  - Kuhsaft::Page.translation_locales.each do |locale|
    %li{ :class => (:current if params[:locale] == locale.to_s) }= link_to locale.to_s, cms_projects_path(:locale => locale)

%ul.pages-root.sortable
  -@projects.each do |project|
    %li.can-drag.project
      .branch
        =link_to project.name, cms_project_path(project)
```

Note that we can acess the admin_toolbar and the language tabs from here
as well.

Finally, you need to create a partial called
`_admin_navigation.html.haml` in `app/views/cms/`. This partial is used
to render the additional navigation tabs in the Kuhsaft UI:

```ruby
= admin_tab('Projects', cms_projects_path())
```

# LICENSE

See the file LICENSE.
