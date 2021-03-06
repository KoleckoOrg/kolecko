class TeamsController < ApplicationController
  include ControllerParams

  skip_before_action :authenticate_team!, if: :skip_authenticate_team

  #def new
  #end

  #def create
  #  @team = Team.new(team_params)
  #  @team.payed = false

  #  @team.save
  #  redirect_to login_path
  #end

  def show
    @team = Team.find(params[:id])
  end

  def edit
  end

  def update
  end

  def index
    @teams = Team.where(admin: false)

    respond_to do |format|
      format.js { render layout: false }
      format.json { render layout: false }
      format.html
    end
  end

  private
    def skip_authenticate_team
      action_name == 'index' && request.format.json?
    end
end
