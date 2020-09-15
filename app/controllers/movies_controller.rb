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
    @all_ratings = Movie.ratings
    
    #these arrays will be updated later on
    @sort             = []
    @select = []
    
    
    redirect= false
    
    #if hash containing ratings is not empty
    if !(params[:ratings]).nil?
      params[:ratings].each {|key, value| @select << key}
      session[:ratings] = @select
      
    #if hash containing ratings is empty (going back for example, restore to previous session ratings and then redirect)
    elsif !(session[:ratings]).nil?
        @select = session[:ratings]
        redirect = true
    end
    
    #similar logic follows here as above
    if !(params[:sort]).nil?
      @sort = params[:sort]
      session[:sort] = @sort
    elsif !(session[:sort]).nil?
      @sort = session[:sort]
      redirect = true
    end
    
    #style
      if @sort == 'title'
        @css_title = 'hilite'
      elsif @sort == 'release_date'
        @css_release_date = 'hilite'
      end
    #
    
    if redirect == true
      redirect_to movies_path :ratings=>@select, :sort=>@sort
    else
      @movies = Movie.where(:rating => @select).order(@sort)
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
