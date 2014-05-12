require 'rails/generators'

module Kuhsaft
  module Assets
    class Install < Rails::Generators::Base
      source_root(File.join(Kuhsaft::Engine.root, '/lib/templates/kuhsaft/assets'))

      def copy_customizations
        custom_css_folder = 'app/assets/stylesheets/kuhsaft/cms/'
        custom_js_folder = 'app/assets/javascripts/kuhsaft/cms/'

        empty_directory custom_css_folder
        empty_directory custom_js_folder

        copy_file 'customizations.css.sass', "#{custom_css_folder}/customizations.css.sass"
        copy_file 'customizations.js.coffee', "#{custom_js_folder}/customizations.js.coffee"
        copy_file 'ck-config.js.coffee', "#{custom_js_folder}/ck-config.js.coffee"

        inject_into_file 'config/environments/production.rb', after: /config\.assets\.precompile.*$/ do
          "\n  config.assets.precompile += %w( kuhsaft/cms/customizations.css kuhsaft/cms/customizations.js )"
        end
      end
    end
  end
end
