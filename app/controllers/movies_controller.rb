class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unWique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @allRatings = Movie.GetRatingTypes
    #puts session
    
  #  if (params[:sortingOption].nil? && params[:ratings].nil?)
  #    if(!(session[:sortingOption].nil? && session[:ratings].nil?))
  #    redirect_to movies_path(:sortingOption => session[:sortingOption], :ratings => session[:ratings])
  #    end
  #  end
    
    if(params[:sortingOption].nil? && !session[:sortingOption].nil?)
      params[:sortingOption] = session[:sortingOption]
    end
    if(params[:ratings].nil? && !session[:ratings].nil?)
      params[:ratings] = session[:ratings]
    end

    
    sortingOption = params[:sortingOption]
    if(sortingOption == "Title")
      @movies = Movie.order(:title)
    end
    if(sortingOption == "ReleaseDate")
      @movies = Movie.order(:release_date)
    end
    
    @selectedRatings = @allRatings
    if(params[:ratings].nil?)
      @movies = @movies.where(rating: @allRatings)
    else
      @movies = @movies.where(rating: params[:ratings].keys)
      @selectedRatings = params[:ratings].keys
    end
    
    
    session[:ratings] = params[:ratings]
    session[:sortingOption] = params[:sortingOption]
    
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
