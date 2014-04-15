require 'spec_helper'

describe TeeTimesController do
  describe "index" do
    describe "valid" do
      it "index" do
        get :index
        expect(response).to be_success
      end

      it "index with date range" do
        get :index, date: "2014-04-15"
        expect(assigns(:selected_date)).to eq(Time.zone.parse("2014-04-15").to_date)
        expect(response).to be_success
      end
    end

    describe "invlad" do
      it "invalid date range" do
        get :index, date: "2014-44-15"
        expect(response).to redirect_to(root_url)
      end

      it "invalid date range" do
        get :index, date: ""

        expect(assigns(:selected_date)).to eq(Time.zone.today)
        expect(response).to be_success
      end
    end
  end


end