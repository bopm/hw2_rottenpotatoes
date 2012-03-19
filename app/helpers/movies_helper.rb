module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def join_ratings(order)
    {:order => order}.merge({:ratings => params[:ratings]})
  end
end
