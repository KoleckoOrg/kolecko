class TeamMessage < ApplicationRecord
  belongs_to :team
  belongs_to :message
end
