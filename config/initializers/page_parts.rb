# Dir.glob("#{Kuhsaft::Engine.root}/app/models/kuhsaft/page_part/*.rb").sort.each { |file| require file }

# # https://rails.lighthouseapp.com/projects/8994/tickets/6306-collection-associations-build-method-not-supported-for-sti
# # updated: https://github.com/rails/rails/issues/815

# class ActiveRecord::Reflection::AssociationReflection
#   def build_association(*opts)
#     col = klass.inheritance_column.to_sym
#     if (h = opts.first).is_a? Hash and (type = h.symbolize_keys[col]) and type.to_s.constantize.class == Class
#       opts.first[col].to_s.constantize.new(*opts)
#     elsif klass.abstract_class?
#       raise "#{klass.to_s} is an abstract class and can not be directly instantiated"
#     else
#       klass.new(*opts)
#     end
#   end
# end
