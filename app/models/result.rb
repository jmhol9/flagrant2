class Result < ApplicationRecord
    validates :team_id, :game_id, presence: true
    validates :win, inclusion: { in: [true, false] }

    belongs_to :team
    belongs_to :game

    def loss?
        !win
    end
    
    def matches_pick(pick)
        round_id == pick.round_id && team_id == pick.team_id
    end
end
