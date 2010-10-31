namespace :mongo do
  desc "Reset Mongo db"
  task :reset => :environment do
    db = MongoMapper.database
    puts "Dropping all Collections from #{db.name}"
    db.collections.collect do |collection|
      unless collection.name == "system.indexes"
        puts "Dropping #{collection.name}"
        db.drop_collection(collection.name)
      end
    end
  end
end