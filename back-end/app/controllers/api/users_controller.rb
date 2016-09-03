class Api::UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    users = User.all
    render json: { users: users }
  end

  def new
    @current_user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      #note using json and not text here
      render json: user.access_token, status 201
    else
      render json: { error: user.errors.full_messages }, status: 422
    end
  end

  def show
    user = User.find(params[:id])
    if user == @current_user
      messages = user.messages
      stories = user.stories
      render json: { user: user, messages: messages, stories: stories }
    else
      stories = user.stories
      render json: { user: user, stories: stories }
    end
  end

  def update
    if @current_user.update_attributes(user_params)
      render text: "Account has been updated successfully", status: 200
    else
      render json: @current_user.errors, status: 422
    end
  end

  def edit
    if @current_user
      render json: @current_user, only: [:username, :name, :location, :bio, :resource_request, :skills, :seeking, :preferred_contact],  status: 200
    else
      render text: "Error, users can only edit themselves", status: 422
    end
  end

  def destroy
   if user.destroy
     render text: "Account has been deleted successfully", status: 200
   else
     render text: "Something went wrong, account has not been deleted", status: 422
   end
  end

  private
    # Use callback to share common setup/constraints between actions.
    def set_user
      @current_user = User.find_by(access_token: params[:access_token])
    end

    def user_params
      params.require(:user).permit(:username, :name, :location, :bio, :resource_request, :skills, :seeking, :preferred_contact, :password, :password_confirmation)
    end
end
