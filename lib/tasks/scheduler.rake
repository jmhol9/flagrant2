desc "This task is called by the Heroku scheduler add-on"
task :score_and_cache => :production do
  Tournament.score_and_cache(Tournament.first)
end
