class NovelsController < ApplicationController
  before_action :set_novel, only: %i[show edit update destroy confirm_password password_prompt]
  before_action :require_password_confirmation, only: [:edit]

  # GET /novels or /novels.json
  def index
    @novels = Novel.all
  end

  # GET /novels/1 or /novels/1.json
  def show
  end

  # GET /novels/new
  def new
    @novel = Novel.new
  end

  # GET /novels/1/edit
  def edit
      @novel = Novel.find(params[:id])

  # パスワード確認が必要
  unless session[:novel_password] == @novel.password
    redirect_to password_prompt_novel_path(@novel)
  end

  # POST /novels or /novels.json
  def create
    @novel = Novel.new(novel_params)

    respond_to do |format|
      if @novel.save
        format.html { redirect_to @novel, notice: "Novel was successfully created." }
        format.json { render :show, status: :created, location: @novel }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @novel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /novels/1 or /novels/1.json
  def update
    @novel = Novel.find(params[:id])
    if @novel.update(novel_params)
      redirect_to @novel, notice: 'Novel was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @novel = Novel.find(params[:id])
    @novel.destroy
    redirect_to novels_url, notice: 'Novel was successfully destroyed.'
  end

  # POST /novels/:id/confirm_password
  def confirm_password
    if @novel.authenticate(params[:password])
      session[:confirmed_novel_id] = @novel.id
      redirect_to edit_novel_path(@novel)
    else
      flash[:alert] = "パスワードが正しくありません。"
      render :password_prompt
    end
  end

  # GET /novels/:id/password_prompt
  def password_prompt
    # ユーザーにパスワード入力を求める
  end

  private

  def set_novel
    @novel = Novel.find(params[:id])
  end

  def require_password_confirmation
    unless session[:confirmed_novel_id] == @novel.id
      flash[:alert] = "パスワード認証が必要です。"
      redirect_to password_prompt_novel_path(@novel)
    end
  end

  def novel_params
    params.require(:novel).permit(:title, :author, :publish, :password, :password_confirmation, :novel_body, :point, :novel_tags)
  end
end
end