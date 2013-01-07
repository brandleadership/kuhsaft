namespace :kuhsaft do
  namespace :db do
    desc "Load kuhsaft seeds"
    task :seed => :environment do
      Kuhsaft::Engine.load_seed
    end
  end
end

Rake::Task['db:seed'].enhance ['kuhsaft:db:seed']
