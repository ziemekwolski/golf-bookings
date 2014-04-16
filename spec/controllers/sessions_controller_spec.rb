require 'spec_helper'

describe SessionsController do

  def valid_login
    {
      email: "default@test.com",
      password: "asdfasdf"
    }
  end

  def invalid_login
    {
      email: "default@test.com",
      password: "wrong_pass"
    }
  end
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    it "returns http success" do
      post 'create', session: valid_login
      expect(response).to redirect_to clubs_url
      
    end
  end

  describe "invalid POST 'create'" do
    it "returns http success" do
      post 'create', session: invalid_login
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end
end
