class UpdatesController < ApplicationController
    def index
        @updates = Update.all.includes(:author)
    end
end
