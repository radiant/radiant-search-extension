namespace :radiant do
  namespace :extensions do
    namespace :search do
      
      desc "Runs the migration of the Search extension"
      task :migrate do
        require 'extension_migrator'
        SearchExtension.migrator.migrate
      end
    
    end
  end
end