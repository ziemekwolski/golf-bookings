require 'spec_helper'

describe UsersController do

  def valid_params
    {
      name: "bob",
      email: "test@test.com",
      password: "test",
      password_confirmation: "test"
    }
    
  end

  describe "GET 'signup'" do
    it "returns http success" do
      get :new
      expect(response).to be_success
    end
  end

  describe "POST signup" do
    it "Successful signup" do
      expect{
        post :create, user: valid_params
      }.to change{User.count}.by(1)
      expect(response).to redirect_to login_url
      
    end

    it "Failed signup" do
      expect{
        post :create, user: {email: "", password: "", password_confirmation: ""}
      }.to change{User.count}.by(0)
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end
end
