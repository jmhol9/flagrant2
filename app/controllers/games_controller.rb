class GamesController < ApplicationController
    before_action :redirect_unless_admin

    def index 
        @teams = Team.all.sort_by {|team| [team.region, team.seed] }
        @games = Game.all.sort_by {|game| [game.home_team.region, game.home_team.seed] }
        @rounds = Round.all
        @tournaments = Tournament.all
        @game = Game.new
    end

    def create
        @game = Game.new(game_params)

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
