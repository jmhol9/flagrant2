class Tournament < ApplicationRecord
    has_many :entries
    has_many :rounds
    has_many :users, through: :entries

    def picks_open?
        if rounds.empty?
            return false
        end

        now = DateTime.now
        rounds
            .select {|round| round.picks_open? }
            .any?
    end
end
