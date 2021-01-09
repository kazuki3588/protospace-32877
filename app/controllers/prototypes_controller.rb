class PrototypesController < ApplicationController

  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :move_to_index, except: [:index, :show]

  def index
    @prototypes = Prototype.includes(:user)
  end
   
  def new
    @prototype = Prototype.new
  end
  
  def create

    if Prototype.create(prototype_params)
      redirect_to show
    else
      render :new
    end
    
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update

    if prototype = Prototype.find(params[:id])
       prototype.update(prototype_params)
      redirect_to prototype_path(prototype.id)
    else
      render :edit
    end

  end

  def destroy
    if prototype = Prototype.find(params[:id])
       prototype.destroy
      redirect_to root_path
    end
  end

  private
  
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    @prototype = Prototype.find(params[:id])
    unless @prototype.user_id == current_user.id
      redirect_to action: :index
    end
  end

end
