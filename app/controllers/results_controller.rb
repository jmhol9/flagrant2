class ResultsController < ApplicationController
    before_action :redirect_unless_admin

    def create
        result_win = Result.new(result_params)
        result_loss = Result.new({win: false, game_id: result_params[:game_id]})
        game = Game.find(result_params[:game_id])

        # find team to give loss
        if game.home_team_id == result_win.team_id
            result_loss.team_id = game.away_team_id
        else 
            result_loss.team_id = game.home_team_id
        end

        # try to save...
        if !(result_win.save && result_loss.save)
            flash[:errors] = result.errors.full_messages
        end
        redirect_to games_url
    end

    private
    def result_params
        params.require(:result).permit(:win, :team_id, :game_id)
    end
end
