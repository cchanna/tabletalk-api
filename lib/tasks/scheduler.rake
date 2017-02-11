desc "This task is called by the Heroku scheduler add-on"
task :clean_old_chats => :environment do
  puts "Cleaning up chats older than a month..."
  Chat.where('created_at < ?', 1.month.ago).destroy_all
  puts "done"
end
