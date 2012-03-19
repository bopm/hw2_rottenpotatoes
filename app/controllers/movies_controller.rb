class MoviesController < ApplicationController
  before_filter :set_filters_orders, :only => :index

  def set_filters_orders
    redirect_needed = false
    if !params[:order].blank? and session[:order] != params[:order]
      session[:order] = params[:order]
      redirect_needed = true
    end
    if !params[:ratings].blank? and session[:ratings] != params[:ratings]
      session[:ratings] = params[:ratings] unless params[:ratings].blank?
      redirect_needed = true
    end
    redirect_to movies_path(:order => session[:order], :ratings => session[:ratings]) if redirect_needed
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
    movies = Movie
    unless params[:order].blank?
      if params[:order] == 'title'
        movies = movies.order(:title)
      else
        movies = movies.order(:release_date)
      end
    end
    movies = movies.where("rating in (?)",params[:ratings].keys) unless params[:ratings].blank?
    @movies = movies.all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
