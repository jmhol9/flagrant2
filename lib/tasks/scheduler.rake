desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :production do
  Tournament.score_and_cache(Tournament.first)
end
