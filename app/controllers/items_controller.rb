class ItemsController < ApplicationController
  def new
    @list = List.find(params[:list_id])
    @item = @list.items.build
  end

  def create
    @list = List.find(params[:list_id])
    @item = @list.items.build(item_params)

    if @item.save
      redirect_to @list, notice: 'Item successfully added to the list.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @list = List.find(params[:list_id])
    @item = @list.items.find(params[:id])
  end

  def update
    @list = List.find(params[:list_id])
    @item = @list.items.find(params[:id])

    if @item.update(item_params)
      redirect_to list_path(@list), notice: 'Item was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list = List.find(params[:list_id])
    @item = @list.items.find(params[:id])
    @item.destroy
    redirect_to list_path(@list), notice: "Item was successfully deleted."
  end

  private

  def item_params
    params.require(:item).permit(:name)
  end
end