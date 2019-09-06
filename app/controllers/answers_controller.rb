class AnswersController < ApplicationController
  include ControllerParams

  def index
    @answers = current_team.answers
  end

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if @puzzle
      @visit = @puzzle.visits.find_by(team: current_team)
      #FIXME: I want the last hint_request, will this work? Are they ordered chronologically?
      @hint_request = @visit.hint_requests.last

      if @visit
        if @visit.solved?
          flash[:alert] = 'Šifra už byla vyřešena'
          redirect_to new_answer_path
          return
        end

        #Check here for pending hint request rating
        if @hint_request
          if @hint_request.closed == false
            if @hint_request.hints.where(opened: true).count > 0
              flash[:alert] = 'Před odesláním odpovědi je třeba ohodnotit nápovědu.'
              redirect_to queue_hint_requests_path
            end
          end
        end

        @answer.visit = @visit
        @answer.solution = @puzzle.solutions.find_by(text: @answer.text.normalize)

        if @answer.save
          if @answer.correct?

            # Check for pending hint_request and cancel
            if @hint_request
              if @hint_request.closed == false

                @hint_request.cancelled = true
                count = @hint_request.hints.count
                # If no hint was received, just return 70% of the points to the team
                if count == 0
                  amount = @hint_request.bounty * 7 / 10
                  current_team.points += amount
                  ot = OcoinTransaction.new(team: current_team, points: amount,
                                message: '70% bodů zpět za nevyužitou nápovědu k šifře %s' \
                                % @hint_request.visit.puzzle.name)
                  ot.save

                # else split it between all teams which sent hints
                else
                  @hint_request.hints.each do |h|
                    t = Team.find_by(id: h.team_id)
                    amount = @hint_request.bounty * 7 / 10 / count
                    t.points += amount
                    ot = OcoinTransaction.new(team: t, points: amount,
                                  message: 'Odměna za nápovědu k %s' \
                                  % @hint_request.visit.puzzle.name)
                    ot.save
                    t.save
                  end
                end
                @hint_request.save
              end
            end

            ot = OcoinTransaction.new(team: current_team, points: @answer.solution.points,
                                     message: 'Řešení šifry %s' % @puzzle.name)
            ot.save

            current_team.points += @answer.solution.points
            current_team.save

            total_solutions = @puzzle.solutions.count
            found_solutions = @visit.solutions.count

            flash[:success] = "Správná odpověď"
            if total_solutions > 1
              flash[:success] << " (#{found_solutions}/#{total_solutions})"
            end

          else
            flash[:alert] = 'Špatná odpověď'
            #FIXME: Substract points here if too many bad answers
            @visit.wrong_answers += 1
          end
          @visit.save
        else
          flash[:alert] = @answer.errors.full_messages.join('<br>')
        end

      else
        flash[:alert] = 'Nejprve musíte odeslat svůj příchod na stanoviště'
        redirect_to new_visit_path
        return
      end

    else
      flash[:alert] = 'Neplatný kód stanoviště'
    end

    redirect_to new_answer_path
  end
end
