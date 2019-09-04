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
    elsif @hint.hint_request.closed
      flash[:alert] = 'Žádost o nápovědu již není aktivní (tým využil nápovědu od někoho jiného)'
    else
      if @hint.save
        flash[:success] = 'Nápověda odeslána'
      else
        flash[:alert] = @hint.errors.full_messages.join('<br>')
        redirect_to answer_hint_request_path
        return
      end
    end
    redirect_to queue_hint_requests_path
  end

  def edit
  end

  def update
    @hint = Hint.find(params[:id])

    if @hint.update(hint_params)
      flash[:success] = 'Hodnocení odesláno'
    else
      flash[:alert] = 'Hodnocení se nepodařilo odeslat'
    end

    redirect_to hint_requests_path
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
