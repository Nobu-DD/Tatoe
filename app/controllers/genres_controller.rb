class GenresController < ApplicationController
  def create
    genre = Genre.build(genre_param)
    if genre.save
      render json: genre
    else
      flash.now.alert = t("genre.create.failure")
    end
  end

  private

  def genre_param
    params.require(:genre).permit(:name)
  end
end
