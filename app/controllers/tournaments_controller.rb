class TournamentsController < ApplicationController
    def index
        @tournaments = Tournament.all
    end

    def show
        @tournament = Tournament.find(params[:id])
        @current_user_has_entered = current_user.tournaments.include?(@tournament)
    end
end
