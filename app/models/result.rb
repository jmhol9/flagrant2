class Result < ApplicationRecord
    validates :team_id, :game_id, presence: true
    validates :win, inclusion: { in: [true, false] }

    belongs_to :team
    belongs_to :game
end
