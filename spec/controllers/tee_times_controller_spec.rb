require 'spec_helper'

describe TeeTimesController do

  let(:user) {users(:default)}

  before(:each) do
    login_user(user)
  end

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
        expect(response).to redirect_to(tee_times_url)
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
      expect(response).to redirect_to(tee_times_url(date:today_at("9:20am").to_date))
    end

    it "invalid create" do
      expect{
        post :create, tee_time: {booking_time: ""}
      }.to change(TeeTime, :count).by(0)
      expect(response).to redirect_to(tee_times_url)
    end
  end

  describe "Cancel booking" do
    let(:tee_time) {TeeTime.create!(booking_time: today_at("9am"))}
    let(:past_one) {TeeTime.create!(booking_time: (today_at("9am") - 1.day))}

    it "valid cancel" do
      tee_time

      expect{
        delete :destroy, id: tee_time
      }.to change(TeeTime, :count).by(-1)
      expect(response).to redirect_to(tee_times_url(date: tee_time.booking_time.to_date))
    end

    it "invalid cancel" do
      past_one

      expect{
        delete :destroy, id: past_one
      }.to change(TeeTime, :count).by(0)
      expect(response).to redirect_to(tee_times_url)
    end
  end


end