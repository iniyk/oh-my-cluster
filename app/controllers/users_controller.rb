require 'digest'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    md5 = Digest::MD5.new
    md5 << params[:password]
    password_md5 = md5.hexdigest

    @user = User.new(user_params)
    @user.passwd_md5 = password_md5
    @user.role = params[:role].to_i
    @user.group = params[:group].to_i

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    user_params_submit = user_params.clone
    user_params_submit[:role] = params[:role].to_i
    user_params_submit[:group] = params[:group].to_i
    if params[:password] == ""
      md5 = Digest::MD5.new
      md5 << params[:password]
      password_md5 = md5.hexdigest
      user_params_submit['passwd_md5'] = password_md5
    else
      user_params_submit['passwd_md5'] = @user.passwd_md5
    end

    respond_to do |format|
      if @user.update(user_params_submit)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :info)
    end
end
