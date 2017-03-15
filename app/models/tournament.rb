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

    def self.score(tournament)
        Tournament
            .includes(:entries, :picks, :games, :rounds, :results)
            .find(tournament.id)
            .entries
            .reduce(Hash.new) do |memo, entry| 
                # make a hash of usernames & picks
                entry_picks = entry.picks
                memo[entry.user] = entry_picks
                memo
            end
            
    end
end
