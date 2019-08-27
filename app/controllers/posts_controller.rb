class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update]
  rescue_from Exception do |e|
    render json: { error: e.message }, status: :internal_error
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # GET /post
  def index
    @posts = Post.where(published: true)
    if !params[:search].nil? && params[:search].present?
      @posts = PostsSearchService.search(@posts, params[:search])
    end
    render json: @posts.includes(:user), status: :ok
  end

  # GET /post/{id}
  def show
    @post = Post.find(params[:id])
    render json: @post, status: :ok
  end

  # POST /post
  def create
    @post = Post.create!(create_params)
    render json: @post, status: :created
  end

  # PUT /post/{id}
  def update
    @post = Post.find(params[:id])
    @post.update!(update_params)
    render json: @post, status: :ok
  end

  private

  def create_params
    params.require(:posts).permit(:title, :content, :published, :user_id)
  end

  def update_params
    params.require(:posts).permit(:title, :content, :published)
  end

  def authenticate_user!
    # verificar formato Bearer xxxx
    token_regex = /Bearer (\w+)/
    # leer los headers
    headers = request.headers
    # verificar que sea valido
    if headers['Authorization'].present? && headers['Authorization'].match(token_regex)
      token = headers['Authorization'].match(token_regex)[1]
      # verificar que el token corresponda a un usuario
      if (Current.user = User.find_by_auth_token(token))
        return
      end
    end
    render json: {error: 'Unauthorized'}, status: :unauthorized
  end
end