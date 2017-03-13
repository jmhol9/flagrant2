class Team < ApplicationRecord
    validates :region, inclusion: { in: ["West", "South", "Midwest", "East"] }
end
