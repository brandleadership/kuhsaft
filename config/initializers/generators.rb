#Rails.application.config.generators do |g|
#    g.template_engine = :haml
#end

# Why, WHYYYYY!!!
require 'haml'
Haml.init_rails(binding)