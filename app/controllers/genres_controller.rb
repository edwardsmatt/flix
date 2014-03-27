class GenresController < ApplicationController
  before_action :require_signin
  before_action :require_admin
  before_action :find_genre, except: [:index, :new, :create]

  def index
    @genres = Genre.all
  end

  def show
    @movies = @genre.movies
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre, notice: "Genre successfully updated!"
    else
      render :edit
    end
  end

  def new
    @genre = Genre.new
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      redirect_to @genre, notice: "Genre successfully created!"
    else
      render :new
    end
  end

  def destroy
     @genre.destroy
    redirect_to genres_url, alert: "Genre successfully deleted!"
  end

  private
  def find_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
