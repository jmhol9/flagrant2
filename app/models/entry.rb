class Entry < ApplicationRecord
    belongs_to :tournament
    belongs_to :user
    has_many :picks

    def round_budget
        points / 2
    end

    def round_budget_spent(round)
        picks
            .select { |pick| pick.round_id == round.id }
            .map(&:points)
            .sum
    end

    def round_budget_remaining(round)
        round_budget - round_budget_spent(round)
    end
end
