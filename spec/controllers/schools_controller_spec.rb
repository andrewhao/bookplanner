require 'spec_helper'

describe SchoolsController do

  # This should return the minimal set of attributes required to create a valid
  # School. As you add validations to School, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SchoolsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all schools as @schools" do
      school = School.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:schools)).to eq([school])
    end
  end

  describe "GET show" do
    it "assigns the requested school as @school" do
      school = School.create! valid_attributes
      get :show, {:id => school.to_param}, valid_session
      expect(assigns(:school)).to eq(school)
    end
  end

  describe "GET new" do
    it "assigns a new school as @school" do
      get :new, {}, valid_session
      expect(assigns(:school)).to be_a_new(School)
    end
  end

  describe "GET edit" do
    it "assigns the requested school as @school" do
      school = School.create! valid_attributes
      get :edit, {:id => school.to_param}, valid_session
      expect(assigns(:school)).to eq(school)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new School" do
        expect {
          post :create, {:school => valid_attributes}, valid_session
        }.to change(School, :count).by(1)
      end

      it "assigns a newly created school as @school" do
        post :create, {:school => valid_attributes}, valid_session
        expect(assigns(:school)).to be_a(School)
        expect(assigns(:school)).to be_persisted
      end

      it "redirects to the school index page" do
        post :create, {:school => valid_attributes}, valid_session
        expect(response).to redirect_to(schools_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved school as @school" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(School).to receive(:save).and_return(false)
        post :create, {:school => { "name" => "invalid value" }}, valid_session
        expect(assigns(:school)).to be_a_new(School)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(School).to receive(:save).and_return(false)
        post :create, {:school => { "name" => "invalid value" }}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested school" do
        school = School.create! valid_attributes
        # Assuming there are no other schools in the database, this
        # specifies that the School created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        expect_any_instance_of(School).to receive(:update).with({ "name" => "MyString" })
        put :update, {:id => school.to_param, :school => { "name" => "MyString" }}, valid_session
      end

      it "assigns the requested school as @school" do
        school = School.create! valid_attributes
        put :update, {:id => school.to_param, :school => valid_attributes}, valid_session
        expect(assigns(:school)).to eq(school)
      end

      it "redirects to the school" do
        school = School.create! valid_attributes
        put :update, {:id => school.to_param, :school => valid_attributes}, valid_session
        expect(response).to redirect_to(school)
      end
    end

    describe "with invalid params" do
      it "assigns the school as @school" do
        school = School.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(School).to receive(:save).and_return(false)
        put :update, {:id => school.to_param, :school => { "name" => "invalid value" }}, valid_session
        expect(assigns(:school)).to eq(school)
      end

      it "re-renders the 'edit' template" do
        school = School.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(School).to receive(:save).and_return(false)
        put :update, {:id => school.to_param, :school => { "name" => "invalid value" }}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested school" do
      school = School.create! valid_attributes
      expect {
        delete :destroy, {:id => school.to_param}, valid_session
      }.to change(School, :count).by(-1)
    end

    it "redirects to the schools list" do
      school = School.create! valid_attributes
      delete :destroy, {:id => school.to_param}, valid_session
      expect(response).to redirect_to(schools_url)
    end
  end

end
