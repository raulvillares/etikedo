require "rails_helper"

RSpec.describe ItemsController do
  describe "GET new" do
    it "renders the new item page" do
      list = List.create(title: "Test List")

      get :new, params: { list_id: list.id }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(assigns(:list)).to eq(list)
      expect(assigns(:item)).to be_a_new(Item)
    end
  end

  describe "POST create" do
    context "happy path" do
      it "creates a new item in the list" do
        list = List.create(title: "Test List")

        expect do
          post :create, params: { list_id: list.id, item: { name: "An item name" } }
        end.to change(Item, :count).by(1)

        expect(response).to redirect_to(list_path(list))
        expect(flash[:notice]).to eq("Item successfully added to the list.")
      end
    end

    context "with invalid item name" do
      it "does not create the index and renders the new template" do
        list = List.create(title: "Test List")

        expect do
          post :create, params: { list_id:  list.id, item: { name: "" } }
        end.not_to change(Item, :count)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "with duplicated item name" do
      it "does not create the index and renders the new template" do
        list = List.create(title: "Test List")
        Item.create(name: "Item name", list:)

        expect do
          post :create, params: { list_id:  list.id, item: { name: "Item name" } }
        end.not_to change(Item, :count)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when list does not exist" do
      it "redirects to the lists index page with a not found message" do
        expect do
          post :create, params: { list_id: "non_existing_list_id", item: { name: "An item name" } }
        end.not_to change(Item, :count)

        expect(response).to redirect_to(lists_path)
        expect(flash[:alert]).to eq("List not found.")
      end
    end
  end

  describe "GET edit" do
    context "happy path" do
      it "renders the edit item page" do
        list = List.create(title: "Test List")
        item = Item.create(name: "Item name", list:)

        get :edit, params: { list_id: list.id, id: item.id }

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
        expect(assigns(:list)).to eq(list)
        expect(assigns(:item)).to eq(item)
      end
    end

    context "when list does not exist" do
      it "redirects to the lists index page with a not found message" do
        list = List.create(title: "Test List")
        item = Item.create(name: "Item name", list:)

        get :edit, params: { list_id: "non_existing_list_id", id: item.id }

        expect(response).to redirect_to(lists_path)
        expect(flash[:alert]).to eq("List not found.")
      end
    end

    context "when item does not exist" do
      it "redirects to the list page with a not found message" do
        list = List.create(title: "Test List")

        get :edit, params: { list_id: list.id, id: "non_existing_item_id" }

        expect(response).to redirect_to(list_path(list.id))
        expect(flash[:alert]).to eq("Item not found.")
      end
    end
  end

  describe "PUT update" do
    context "happy path" do
      it "updates item and redirects to list page with successful message" do
        list = List.create(title: "Test List")
        item = Item.create(name: "Item name", list:)

        put :update, params: { list_id: list.id, id: item.id, item: { name: "New item name" } }

        item.reload
        expect(item.name).to eq "New item name"
        expect(response).to redirect_to(list_path(list.id))
        expect(flash[:notice]).to eq("Item was successfully updated.")
      end
    end

    context "when item can't be updated" do
      it "does not update the item and renders the edit item page" do
        list = List.create(title: "Test List")
        item = Item.create(name: "Item name", list:)

        put :update, params: { list_id: list.id, id: item.id, item: { name: "" } }

        item.reload
        expect(item.name).to eq "Item name"
        expect(response).to render_template(:edit)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when item does not exist" do
      it "redirects to the list page with a not found message" do
        list = List.create(title: "Test List")

        put :update, params: { list_id: list.id, id: "non_existing_item_id" }

        expect(response).to redirect_to(list_path(list.id))
        expect(flash[:alert]).to eq("Item not found.")
      end
    end

    context "when list does not exist" do
      it "redirects to the lists index page with a not found message" do
        list = List.create(title: "Test List")
        item = Item.create(name: "Item name", list:)

        put :update, params: { list_id: "non_existing_list_id", id: item.id }

        expect(response).to redirect_to(lists_path)
        expect(flash[:alert]).to eq("List not found.")
      end
    end
  end

  describe "DELETE destroy" do
    context "happy path" do
      it "deletes the item and redirects to list page with successful message" do
        list = List.create(title: "Test List")
        item = Item.create(name: "Item name", list:)

        expect do
          delete :destroy, params: { list_id: list.id, id: item.id }
        end.to change(Item, :count).by(-1)

        expect(response).to redirect_to(list_path(list.id))
        expect(flash[:notice]).to eq("Item was successfully deleted.")
      end
    end

    context "when item does not exist" do
      it "redirects to the list page with a not found message" do
        list = List.create(title: "Test List")

        delete :destroy, params: { list_id: list.id, id: "non_existing_item_id" }

        expect(response).to redirect_to(list_path(list.id))
        expect(flash[:alert]).to eq("Item not found.")
      end
    end

    context "when list does not exist" do
      it "redirects to the lists index page with a not found message" do
        list = List.create(title: "Test List")
        item = Item.create(name: "Item name", list:)

        delete :destroy, params: { list_id: "non_existing_list_id", id: item.id }

        expect(response).to redirect_to(lists_path)
        expect(flash[:alert]).to eq("List not found.")
      end
    end
  end
end
