class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list
  before_action :set_item, only: %i[edit update destroy move assign_label unassign_label]

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
      assign_label
      redirect_to list_path(@list), notice: "Item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    redirect_to list_path(@list), notice: "Item was successfully deleted."
  end

  def move
    @item.insert_at(params[:position].to_i)
    head :ok
  end

  def assign_label
    return if params[:item][:label][:name].blank?

    ActiveRecord::Base.transaction do
      label = Label.find_or_create_by_name(name: params[:item][:label][:name])
      @item.labels << label unless @item.labels.include?(label)
    end
  end

  def unassign_label
    label = @item.labels.find_by(name: params[:label_name])
    @item.labels.destroy(label) if label

    redirect_to edit_list_item_path(@item)
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
    params.require(:item).permit(:name, label_attributes: [:name])
  end
end
