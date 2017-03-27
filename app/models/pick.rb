class Pick < ApplicationRecord
    after_initialize :ensure_multiplier

    validates :entry_id, :round_id, :team_id, :points, presence: true
    validates :multiplier, inclusion: { in: [1, 2] }
    validate :bet_limit_half_total_points_per_round, :one_double_per_round, :one_bet_per_team_per_round, :no_hedge_bets, :no_negative_bets, :limit_max_picks_per_round

    belongs_to :entry
    belongs_to :round
    belongs_to :team
    has_one :user, through: :entry

  def self.user_picks_per_round(user, round)
    # Pick.where(entry_id: entry.id).where(round_id: round.id).includes(:team)
  end

  def game 
    game_one = Game.find_by(round_id: round_id, home_team_id: team_id)
    game_two = Game.find_by(round_id: round_id, away_team_id: team_id)
    game_one || game_two
  end

  private
  def bet_limit_half_total_points_per_round
    total_points_wagered_round = entry.picks.where(round_id: round_id).sum(:points)
    if total_points_wagered_round + points > entry.round_budget
      errors[:pick] << ": You can only wager #{entry.round_budget - total_points_wagered_round} more points in the #{round.name}"
    end
  end

  def pick_round_is_open
    unless pick.round.picks_open?
      errors[:pick] << ": No more picks for that round!"
    end
  end

  def one_double_per_round
    return if self.multiplier == 1
    if Pick.where(
        entry_id: self.entry_id,
        round_id: self.round_id,
        multiplier: 2).any?
      errors[:pick] << ": Only one double per round!"
    end
  end

  def one_bet_per_team_per_round
    if Pick.where(
        entry_id: self.entry_id,
        round_id: self.round_id,
        team_id: self.team_id).any?
      errors[:pick] << ": Already picked that team!"
    end
  end

  def ensure_multiplier
    self.multiplier ||= 1
  end

  def no_negative_bets
    if self.points <= 0
      errors[:pick] << ": You have to wager more than 0 points!"
    end
  end

  def limit_max_picks_per_round
    max_picks = self.round.max_picks
    if max_picks.nil?
      return
    end

    existing_round_picks = Pick.where(entry_id: self.entry_id, round_id: self.round_id)
    if existing_round_picks.count >= max_picks 
      errors[:pick] << ": Only #{ max_picks } #{ self.round.name } pick(s) allowed.)"
    end
  end

  def no_hedge_bets
      game_one = Game.find_by(round_id: self.round_id, home_team_id: self.team_id)
      game_two = Game.find_by(round_id: self.round_id, away_team_id: self.team_id)

      if game_one.nil? && game_two.nil?
          return
      end

      if game_one || game_two
          other_teams_picked = entry.picks.select { |p| p.round_id == self.round_id }.map(&:team)
      end

      if game_one && other_teams_picked.include?(game_one.away_team)
          errors[:pick] << ": No hedge bets! (You already picked #{ game_one.away_team.name }.)"
      end

      if game_two && other_teams_picked.include?(game_two.home_team)
          errors[:pick] << ": No hedge bets! (You already picked #{ game_two.home_team.name }.)"
      end
  end
end
