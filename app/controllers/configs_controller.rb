class ConfigsController < ApplicationController
    before_action :redirect_unless_admin
    
    def index
        @picks = Pick.includes(:round, :team, :user).all.sort_by(&:entry)
    end
end
