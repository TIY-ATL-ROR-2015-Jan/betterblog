class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  # GET /posts
  # GET /posts.json
  def index
    @posts = @user.posts
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html { render :show }
      format.json { @post.to_json }
    end
  end

  # GET /month/2015-01
  def month
    @posts = @user.posts.where("strftime('%Y-%m', created_at) = ?", params[:month])
    render :index
  end

  # GET /posts/new
  def new
    @post = Post.new
    render :new
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  # POST /posts
  # POST /posts.json
  def create
    tags = params.delete(:tags)
    @post = Post.new(post_params)
    @post.user_id = params[:user_id]

    respond_to do |format|
      if @post.save
        sync_post_tags(tags)
        format.html { redirect_to [@user, @post], notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: [@user, @post] }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    tags = params.delete(:tags)
    respond_to do |format|
      if @post.update(post_params)
        sync_post_tags(tags)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def sync_post_tags(tags)
      # map(&:strip) = map { |x| x.strip }
      PostTag.where(:post_id => @post.id).delete_all
      tags.split(',').map(&:strip).each do |t|
        tag = Tag.create_or_find_by(:name => t)
        PostTag.create_or_find_by(:post_id => @post.id,
                                  :tag_id => tag.id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
