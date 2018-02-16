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
    #@movies = Movie.all
    @ratings = params[:ratings]
    @sort = params[:sort_by]
    @all_ratings = Movie.full_ratings
    @set_ratings = params[:ratings]
    redirection = false
	
    if @sort then
	session[:sort_by] = @sort
    elsif session[:sort_by] then
	@sort = session[:sort_by]
	redirection = true
   else
	@sort = nil
    end
#Uncomment to show all options if null.
    if params[:commit] == "Refresh" && @ratings.nil? then
#	session[:ratings] =nil
    elsif @ratings then
	session[:ratings] = @ratings
    elsif session[:ratings] then
	@ratings = session[:ratings]
	redirection = true
    else
        @ratings = nil
     end
	
     if redirection then
	flash.keep
	redirect_to movies_path :sort_by=>@sort, :ratings=>@ratings
     end
#Check which option is chooosed. If none, then show all.
	if @sort && @ratings then
	  @movies = Movie.where(:rating => @ratings.keys).order(@sort)
	elsif @sort then
	  @movies = Movie.order(@sort)
	elsif @ratings then
	  @movies = Movie.where(:rating => @ratings.keys)
	else
	  @movies = Movie.all
	end
#If rating was nil or  then seed hash
       if @ratings.nil? then
               @ratings =  Hash.new
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
