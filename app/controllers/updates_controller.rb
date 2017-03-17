class UpdatesController < ApplicationController
        before_action :redirect_unless_admin, only: [:create]
    
    def index
        @updates = Update.all.includes(:author).sort_by {|update| update.created_at}.reverse
        @update = Update.new
    end

    def create
        @update = Update.new(update_params)
        @update.author_id = current_user.id

        if @update.save
            redirect_to updates_url
        else
            flash[:errors] = @update.errors.full_messages
            redirect_to updates_url
        end
    end

    private 
    def update_params
        params.require(:update).permit(:title, :body)
    end
end
