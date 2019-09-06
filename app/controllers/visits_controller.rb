class VisitsController < ApplicationController
  include ControllerParams

  def index
    @visits = Visit.where(team: current_team).sort_by(&:created_at)
  end

  def map
    @open_puzzles = Puzzle.where('? BETWEEN opens_at AND closes_at', Time.now)
    @visited_puzzles = Visit.where(team: current_team).map(&:puzzle)
    @solved_puzzles = Visit.where(team: current_team)
                           .where.not(solved_at: nil)
                           .map(&:puzzle)
  end

  def new
    @visit = Visit.new
  end

  def create
    @puzzle = Puzzle.find_by_code(puzzle_params[:code])

    if @puzzle
      @visit = Visit.new(puzzle: @puzzle, team: current_team)
      if @visit.save
        if @puzzle.puztype == "secondary"
          current_team.points += @puzzle.points
          ot = OcoinTransaction.new(team: current_team, points: @puzzle.points,
                                    message: 'Vyzvednutí šifry %s' % @puzzle.name)
          ot.save
          current_team.save
        end
        redirect_to visits_path
      else
        flash[:alert] = 'Příchod na stanoviště byl již zaznamenán'
        redirect_to new_visit_path
      end
    else
      flash[:alert] = 'Neplatný kód stanoviště'
      redirect_to new_visit_path
    end
  end
end
