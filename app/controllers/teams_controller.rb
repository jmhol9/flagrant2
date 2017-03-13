class TeamsController < ApplicationController
    before_action :redirect_unless_admin

    def index
        @teams = Team.all.sort_by {|team| [team.region, team.seed] }
        @team = Team.new
    end

    def create
        @team = Team.new(team_params)

        if @team.save
            redirect_to teams_url
        else
            flash[:errors] = @team.errors.full_messages
            redirect_to teams_url
        end
    end

    private
    def team_params
        params.require(:team).permit(:name, :seed, :region)
    end
end
