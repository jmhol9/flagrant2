class Result < ApplicationRecord
    validates :team_id, :round_id, presence: true
    validates :team_id, uniqueness: {scope: :round_id}
    validates :win, inclusion: { in: [true, false] }

    belongs_to :team
    belongs_to :round
end
