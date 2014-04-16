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

  describe "create booking" do
    it "create" do 
      expect{
        post :create, tee_time: {booking_time: today_at("9:20am")}
      }.to change(TeeTime, :count).by(1)
      expect(response).to redirect_to(root_url(date:today_at("9:20am").to_date))
    end

    it "invalid create" do
      expect{
        post :create, tee_time: {booking_time: ""}
      }.to change(TeeTime, :count).by(0)
      expect(response).to redirect_to(root_url)
    end
  end

  describe "Cancel booking" do
    let(:tee_time) {TeeTime.create!(booking_time: today_at("9am"))}

    before(:each){
      tee_time
    }
    
    it "valid cancel" do
      expect{
        delete :destroy, {tee_time: {booking_time: tee_time.booking_time.to_s}}
      }.to change(TeeTime, :count).by(-1)
      expect(response).to redirect_to(root_url(date: tee_time.booking_time.to_date))
    end
  end


end