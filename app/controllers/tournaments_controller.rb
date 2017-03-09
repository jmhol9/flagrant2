class TournamentsController < ApplicationController
    before_action :redirect_if_logged_out

    def index
        @tournaments = Tournament.all
    end

    def show
        @tournament = Tournament.find(params[:id])
        @current_user_has_entered = current_user.tournaments.include?(@tournament)

        @entries = @tournament
                        .entries
                        .includes(:user)
                        .reject { |entry| entry.user.nil? }
                        .sort_by { |entry| -entry[:points] }
    end
end
