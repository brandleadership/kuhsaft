namespace :kuhsaft do
  namespace :db do
    desc "Load kuhsaft seeds"
    task :seed => :environment do
      Kuhsaft::Engine.load_seed
    end
  end
end

Rake::Task['db:seed'].enhance ['kuhsaft:db:seed']

desc "Create nondigest versions of all ckeditor digest assets"
task "assets:precompile" do
  fingerprint = /\-[0-9a-f]{32}\./
  for file in Dir["public/assets/kuhsaft/cms/ck-config*"]
    next unless file =~ fingerprint
    nondigest = file.sub fingerprint, '.'
    if !File.exist?(nondigest) or File.mtime(file) > File.mtime(nondigest)
      FileUtils.cp file, nondigest, verbose: true
    end
  end
end
