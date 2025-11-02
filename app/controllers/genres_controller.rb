class GenresController < ApplicationController
  def create
    @genre = Genre.build(genre_param)
    if @genre.save
      render json: {
        genre: @genre,
        status: "create",
        message: "#{@genre.name}を新規登録しました。"
      },
      status: :created
    else
      render json: {
        status: "unprocessable_entity",
        messages: @genre.errors
      },
      status: "unprocessable_entity"
    end
  end

  private

  def genre_param
    params.require(:genre).permit(:name)
  end
end
