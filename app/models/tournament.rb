class Tournament < ApplicationRecord
    has_many :entries
    has_many :rounds
    has_many :games
    has_many :results, through: :games

    has_many :users, through: :entries
    has_many :picks, through: :entries

    def picks_open?
        if rounds.empty?
            return false
        end

        now = DateTime.now
        rounds
            .select {|round| round.picks_open? }
            .any?
    end

    def scoring_rounds
        closed_rounds = rounds.select { |round| round.picks_close < DateTime.now }
        return [] if closed_rounds.length < 2
        return closed_rounds.last(2)
    end

    def self.score(tournament)
        # set scores = tournament.allowance if we don't have two rounds yet
        scoring_rounds = tournament.scoring_rounds
        scoring_games = tournament.games.select { |game| scoring_rounds.map(&:id).include?(game.round_id)  }
        if scoring_rounds.empty?
            return tournament.entries.reduce(Hash.new) do |memo, entry|
                memo[entry.user] = tournament.allowance
                memo
            end
        end

        # otherwise, do the super reduce
        team_cache = Team.all
        Tournament
            .includes(:entries, :picks, :games, :rounds, :results, :users)
            .find(tournament.id)
            .entries
            .reduce(Hash.new) do |memo, entry| 
                # filter all picks to eliminate those not from the scoring rounds
                scoring_picks = entry
                    .picks
                    .select { |pick| scoring_rounds.map(&:id).include?(pick.round_id) }
                    .select{ |pick| !scoring_games.find { |game| game.matches_pick(pick) }.nil? }

                # make a hash of usernames & picks with game:result
                memo[entry] = scoring_picks.select { |pick| !pick.game.results.empty? }
                memo
            end
            .reduce(Hash.new) do |memo, (entry, picks)|
                memo[entry] = picks.map do |pick|
                    pick_team = team_cache.find { |team| team.id == pick.team_id}
                    {
                        points: pick.points,
                        seed: pick_team.seed == 1 ? 1.5 : pick_team.seed,
                        multiplier: pick.multiplier,
                        result: tournament.games.select { |game| game.round_id == pick.round_id }.flat_map(&:results).find { |result| result.team_id == pick.team_id }
                    }
                end
                memo
            end
            .reduce(Hash.new) do |memo, (entry, pick_outcomes)|
                pick_payouts_arr = pick_outcomes.map do |pick_outcome|
                    pick_outcome[:result].loss? ? 0 : pick_outcome[:points] * pick_outcome[:multiplier] * pick_outcome[:seed]
                end
                memo[entry] = pick_payouts_arr.sum
                memo
            end
    end
end
