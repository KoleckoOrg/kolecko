module HintRequestsHelper
  def star_rating(hint)
    render partial: 'hints/star_rating', locals: { hint: hint }
  end
end
