class Game < ApplicationRecord
    validate :one_game_per_team_per_round, :team_cannot_play_itself
    
    belongs_to :home_team, class_name: "Team", foreign_key: "home_team_id"
    belongs_to :away_team, class_name: "Team", foreign_key: "away_team_id"
    belongs_to :round
    belongs_to :tournament
    has_many :results

    def winner
        winner = results.find { |res| res.win == true }

        return winner.nil? ? nil : winner.team
    end

    def <=>(game)
        if self.round_id != game.round_id
            return self.round_id <=> game.round_id
        elsif self.winner == nil
            return -1
        else
            return 1
        end
    end

    private
    def one_game_per_team_per_round
        if (Game.where(tournament_id: self.tournament_id, home_team_id: self.home_team_id, round_id: self.round_id).any? || 
            Game.where(tournament_id: self.tournament_id, away_team_id: self.away_team_id, round_id: self.round_id).any?)
            errors[:pick] << ": Only one game per team per round!"
        end
    end

    def team_cannot_play_itself
        if (self.home_team_id == self.away_team_id)
            errors[:pick] << ": Team cannot play itself!"
        end
    end
end
