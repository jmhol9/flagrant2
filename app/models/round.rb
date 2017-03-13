class Round < ApplicationRecord
    validates :name, :picks_start, :picks_close, presence: true

    belongs_to :tournament
    has_many :picks
    has_many :results
    has_one :dependent_round

    def self.reverse_chron
        Round.all.sort_by { |round| round.id * -1}
    end

    def <=>(round)
        self.id <=> round.id
    end

    def teams_in_round
        Team.where("
            id NOT IN (
                SELECT
                    team_id
                FROM
                    team_round_results
                WHERE
                    win = false AND
                round_id < #{id}
            )
        ")
    end

    def picks_open?
        now = DateTime.now
        now >= picks_start && now <= picks_close
    end
end
