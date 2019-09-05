class MessagesController < ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def index
    current_team.team_messages.each do |team_message|
      team_message.read = true
      team_message.save!
    end
  end
end
