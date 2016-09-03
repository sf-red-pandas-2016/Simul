class Api::StoriesController < ApplicationController

  def index
    stories = Story.where(user_id: params[:user_id])
    render json: { stories: stories }
  end

  def new
  end

  def create
    if user.id == current_user.id
      story = Story.create
      if story.save
        redirect_to story
      else
        render json: { error: story.errors.full_messages }
      end
    end
  end

  def show
    story = Story.find(params[:id])
    render json: { story: story }
  end

  def update
  end

  def edit
  end

  def destroy
  end

end
