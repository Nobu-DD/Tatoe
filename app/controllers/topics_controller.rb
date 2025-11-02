class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  def index
    @q = Topic.ransack_search(search_params)
    @q.sorts = params[:s].blank? ? "published_at desc" : params[:s]
    @topics = @q.result(distinct: true).includes(:user, :genres, :hints).page(params[:page]).per(10)
  end

  def new
    @topic = Topic.new
    3.times { @topic.hints.build }
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if @topic.save
      redirect_to @topic, notice: t("topic.create.success")
    else
      render :new, status: :unprocessable_entity, alert: t("topic.create.failure")
    end
  end

  def show
    @topic = Topic.includes(:user, :genres, :hints, :answers).find(params[:id])
    @answers = @topic.answers.order(created_at: :desc).page(params[:page]).per(10)
    @reactions = Reaction.all
  end

  def edit
    @topic = current_user.topics.includes(:genres).find(params[:id])
  end

  def update
    @current_path = URI.parse(request.referer).path
    @topic = current_user.topics.find(params[:id])
    if @topic.update(topic_params)
      flash.now.notice = t("topic.update.success")
    else
      flash.now.alert = t("topic.update.failure")
    end
  end

  def destroy
    @current_path = URI.parse(request.referer).path
    @topic = current_user.topics.find(params[:id])
    @topic.destroy!
    @topics = current_user.topics
    flash.now.notice = t("topic.deleted.success")
  end

  def generate_ai
    request_params = params.slice(:genre, :compare)
    response = GeminiGenerationService.new(:topic, request_params).run
    response_hash = JSON.parse(response, symbolize_names: true)
    response_hash[:genres] = Genre.genre_creat_confimation(response_hash[:genres])
    render json: response_hash
  end

  # オートコンプリート用アクション
  def autocomplete
    @genres = Genre.where("name like ?", "%#{params[:q]}%")

    respond_to do |format| 
      format.js
    end
  end

  private

  def topic_params
    params.require(:topic).permit(
      :title, :description, genre_names: [],
      hints_attributes: [ :id, :body, :_destroy ]
    )
  end

  def search_params
    return params[:q] if params[:q].blank?

    params.require(:q).permit(
      :title_or_description_or_genres_name_or_user_name_cont_any, :title_cont_any, :user_name_cont_any, :genres_name_cont_any, :published_at_gteq, :published_at_lteq
    )
  end
end
