class PicksController < ApplicationController
    before_action :redirect_if_logged_out

    def index
        @tournament = Tournament.find(params[:tournament_id])
        if !current_user.registered?(@tournament)
            flash[:errors] = ["You're not registered for this tournament"]
            redirect_to tournament_url(@tournament)
            return
        end

        @rounds = @tournament.rounds.select { |round| round.picks_open? }.sort
        if @rounds.length == 0
            flash[:errors] = ["Picks are closed!"]
            redirect_to tournament_url(@tournament)
            return
        end

        losses_team_ids = Result.all.select { |result| result.loss? }.map(&:team_id)
        @teams = Team
            .all
            .select { |team| !losses_team_ids.include?(team.id) }
            .sort_by { |team| team.seed }
            
        @entry = Entry.includes(:picks).find_by(
            tournament_id: @tournament.id,
            user_id: current_user.id
        )

        @current_picks = @entry.picks.select { |pick| pick.round.picks_open? }

        @pick = Pick.new
    end

    def create
        @pick = Pick.new(pick_params)
        @pick.entry_id = Entry.find_by(user_id: current_user.id, tournament_id: params[:tournament_id]).id

        if @pick.save
            redirect_to tournament_picks_url(params[:tournament_id])
        else
            flash[:errors] = @pick.errors.full_messages
            redirect_to tournament_picks_url(params[:tournament_id])
        end
    end

    def destroy
        pick = Pick.find(params[:id])
        
        if pick.user != current_user
            return
        end
        
        tournament = pick.entry.tournament
        pick.destroy if pick.round.picks_open?
        redirect_to tournament_picks_url(tournament)
    end

    private
    def pick_params
        params.require(:pick).permit(:team_id, :points, :round_id, :multiplier)
    end
end
