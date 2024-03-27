class ListsController < ApplicationController
  before_action :set_list, only: %i[show destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :list_not_found

  def index
    @lists = List.all
  end

  def new
    @list = List.new
  end

  def create
    list_params = params.require(:list).permit(:title)
    @list = List.new(list_params)

    if @list.save
      redirect_to @list
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @list = List.find(params[:id])
  end

  def destroy
    @list = List.find(params[:id])

    @list.destroy
    redirect_to root_path
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def update_params
    params[:list].permit(:new_item_name)
  end

  def list_not_found
    flash[:alert] = "List not found."
    redirect_to lists_path
  end
end
