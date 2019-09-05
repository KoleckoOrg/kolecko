class Message < ApplicationRecord
  has_many :team_messages

  after_create do |message|
    create_team_messages(message)
  end

  def create_team_messages(message)
    Team.all.each do |team|
      TeamMessage.create(team: team, message: message)
    end
  end
end
