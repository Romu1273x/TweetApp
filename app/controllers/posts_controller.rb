class PostsController < ApplicationController
  # before_actionにauthenticate_userメソッドを指定してください
  before_action :authenticate_user
  # before_actionでensure_correct_userメソッドを指定してください
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    # Post.allにorderメソッドを用いて、新しい投稿が上から順に表示されるようにしてください
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id:params[:id])
    # 変数@userを定義してください
    @user = @post.user
    # 変数@likes_countを定義してください
    @likes_count = Like.where(post_id: @post.id).count
  end 

  def new
    @post = Post.new
  end

  def create
    # フォームから送信されたデータを受け取り、保存する処理を追加してください
    @post = Post.new(
      content: params[:content],
      # user_idの値をログインしているユーザーのidにしてください
      user_id: @current_user.id
    )
    if @post.save
      flash[:notice] = "投稿を作成しました"
      # redirect_toメソッドを用いて、自動的に投稿一覧ページに転送されるようにしてください
      redirect_to("/posts/index")
    else
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    # 保存が成功した時は投稿一覧ページ、失敗した時は編集ページにリダイレクトされるように変更してください
    if @post.save
      # 変数flash[:notice]に指定されたメッセージを代入してください
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      # renderメソッドを用いて、editアクションを経由せず、posts/edit.html.erbが表示されるようにしてください
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.destroy
      flash[:notice] = "投稿を削除しました"
      redirect_to("/posts/index")
    end
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
