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
  end

  def create

  end

  def destroy

  end

  private
  def find_genre
    @genre = Genre.find(params[:id])
  end

  def genre_params
    params.require(:genre).permit(:name)
  end
end
