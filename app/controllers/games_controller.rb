class GamesController < ApplicationController
    before_action :redirect_unless_admin

    def index 
        @games = Game
            .includes(:results, :home_team, :away_team)
            .all
            .sort_by { |game| -game.round_id }


        losses_team_ids = Result.all.select { |result| result.loss? }.map(&:team_id)
        @teams = Team.all
            .select { |team| !losses_team_ids.include?(team.id) }
            .sort_by { |team| team.seed }
        @rounds = [Round.second]
        @tournaments = Tournament.all
    end

    def create
        @game = Game.new(game_params)
        @game.tournament_id = Tournament.first.id

        if @game.save
            redirect_to games_url
        else
            flash[:errors] = @game.errors.full_messages
            redirect_to games_url
        end
    end

    private
    def game_params
        params.require(:game).permit(:home_team_id, :away_team_id, :round_id, :tournament_id)
    end
end
