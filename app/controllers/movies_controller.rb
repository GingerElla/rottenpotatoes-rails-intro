class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    new_ratings = false
    new_sorts = false
    
    @all_ratings = Movie.get_all_ratings
    @selected_ratings = params[:ratings]
    if @selected_ratings != nil
      session[:ratings] = @selected_ratings
      @selected_ratings = @selected_ratings.keys
    elsif session[:ratings] != nil
      @selected_ratings = session[:ratings]
      new_ratings = true
    else
      @selected_ratings = @all_ratings
    end
    
    @sort = params[:sort]
    if @sort != nil
      session[:sort] = @sort
    elsif session[:sort] != nil
      @sort = session[:sort]
      new_sort = true
    else
      @sort = ''
    end
    
    if new_ratings || new_sort
      session.clear
      flash.keep
      if new_ratings && new_sort
        redirect_to movies_path(ratings: @selected_ratings, sort: @sort)
      elsif new_ratings
        redirect_to movies_path(ratings: @selected_ratings, sort: params[:sort])
      else
        redirect_to movies_path(sort: @sort, ratings: params[:ratings])
      end
    end
    
    if @sort == 'title'
      @movies = Movie.where({ rating: @selected_ratings }).order(:title)
      @hilite_title = 'hilite'
      @hilite_date = ''
    elsif @sort == 'release_date'
      @movies = Movie.where({ rating: @selected_ratings }).order(:release_date)
      @hilite_title = ''
      @hilite_date = 'hilite'
    else
      @movies = Movie.where({ rating: @selected_ratings })
      @hilite_title = ''
      @hilite_date = ''
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
