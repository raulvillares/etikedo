class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_item, only: %i[edit update destroy]

  def new
    @item = @list.items.build
  end

  def edit; end

  def create
    @item = @list.items.build(item_params)

    if @item.save
      redirect_to @list, notice: "Item successfully added to the list."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @item.update(item_params)
      redirect_to list_path(@list), notice: "Item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to list_path(@list), notice: "Item was successfully deleted."
  end

  private

  def set_list
    @list = List.by_user(current_user).find(params[:list_id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "List not found."
    redirect_to lists_path
  end

  def set_item
    @item = @list.items.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "Item not found."
    redirect_to list_path(@list)
  end

  def item_params
    params.require(:item).permit(:name)
  end
end
