class TournamentsController < ApplicationController
    before_action :redirect_if_logged_out

    def index
        @tournaments = Tournament.all
    end

    def show
        @tournament = Tournament.find(params[:id])
        @current_user_has_entered = current_user.tournaments.include?(@tournament)

        if @current_user_has_entered
            @entered_users = @tournament.users
        end
    end
end
