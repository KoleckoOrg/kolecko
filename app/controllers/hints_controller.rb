class HintsController < ApplicationController
  include ControllerParams

  def index
    @hints = current_team.received_hints.where(opened: true)
    respond_to do |format|
      format.json { render layout: false }
    end
  end

  def queue
  end

  def show
    @hint = Hint.find(params[:id])

    if @hint
      @hint.open
      @hint.save

      respond_to do |format|
        format.js { render layout: false }
        format.json { render layout: false }
      end
    end
  end

  def new
    @hint = Hint.new
  end

  def create
    @hint = Hint.new(hint_params)
    @hint.from_team = current_team
    @request = @hint.hint_request

    if @hint.hint_request.cancelled
      flash[:alert] = 'Žádost o nápovědu byla zrušena'
      redirect_to queue_hint_requests_path
    elsif @hint.hint_request.closed
      flash[:alert] = 'Žádost o nápovědu již není aktivní (tým využil nápovědu od někoho jiného)'
      redirect_to queue_hint_requests_path
    else
      if @hint.save
        flash[:success] = 'Nápověda odeslána'
        redirect_to queue_hint_requests_path
      else
        flash[:alert] = @hint.errors.full_messages.join('<br>')
        redirect_to answer_hint_request_path
      end
    end
  end

  def edit
  end

  def update
    @hint = Hint.find(params[:id])

    respond_to do |format|
      if @hint.update(hint_params)
        format.js { render layout: false }
      end
    end
  end

  def accept
    @hint = Hint.find(params[:id])

    if @hint
      @hint.accept
      @hint.save

      respond_to do |format|
        format.js { render layout: false }
        format.json { render layout: false }
      end
    end
  end

  def destroy
  end
end
