class OcoinTransactionsController < ApplicationController
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def index
    @points = current_team.points
    @ot = OcoinTransaction.where(team: current_team).sort_by(&:created_at)
  end
end
