require "rails_helper"

RSpec.describe ListsController, type: :controller do
  describe "GET index" do
    it "renders the index page for existing lists" do
      list = List.create(title: "A List Title")

      get :index

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:lists)).to eq([list])
    end
  end

  describe "GET new" do
    it "renders the new list page" do
      get :new

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(assigns(:list)).to be_a_new(List)
    end
  end

  describe "POST create" do
    context "happy path" do
      it "creates a new list and redirects to the list's page" do
        post :create, params: { list: { title: "New List Title" } }

        expect(response).to redirect_to(List.last)
        expect(List.count).to eq(1)
      end
    end

    context "with empty title" do
      it "does not create the list and renders the new template" do
        post :create, params: { list: { title: "" } }

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(List.count).to eq(0)
      end
    end

    context "with title that already exists" do
      it "does not create the list and renders the new template" do
        List.create(title: "A List Title")

        post :create, params: { list: { title: "A List Title" } }

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(List.count).to eq(1)
      end
    end
  end

  describe "GET show" do
    context "happy path" do
      it "assigns the show view for the corresponding list" do
        list = List.create!(title: "A List Title")

        get :show, params: { id: list.id }

        expect(assigns(:list)).to eq(list)
        expect(response).to render_template(:show)
      end
    end

    context "when list does NOT exist" do
      it "redirects to the lists index page with a not found message" do
        get :show, params: { id: "nonexistent_id" }

        expect(response).to redirect_to(lists_path)
        expect(flash[:alert]).to eq("List not found.")
      end
    end
  end

  describe "DELETE destroy" do
    context "happy path" do
      it "deletes the list and redirects to root path" do
        list = List.create!(title: "A List Title")

        expect do
          delete :destroy, params: { id: list.id }
        end.to change(List, :count).by(-1)

        expect(response).to redirect_to(root_path)
      end

      it "deletes the associated items" do
        list = List.create!(title: "A List Title")
        Item.create!(name: "An Item Name", list:)

        expect do
          delete :destroy, params: { id: list.id }
        end.to change(Item, :count).by(-1)
      end
    end

    context "when list does NOT exist" do
      it "redirects to the lists index page with a not found message" do
        delete :destroy, params: { id: "nonexistent_id" }

        expect(response).to redirect_to(lists_path)
        expect(flash[:alert]).to eq("List not found.")
      end
    end
  end
end
