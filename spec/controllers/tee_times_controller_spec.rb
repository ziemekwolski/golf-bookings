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

    describe "invalid" do
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
      expect(assigns(:tee_time).user).to eq(user)
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
    let(:current_time) {Time.zone.today.to_time}
    let(:second_user) {users(:second)}
    let(:tee_time) {TeeTime.create!({booking_time: today_at("9am"), user: user})}
    let(:past_one) {TeeTime.create!({booking_time: (today_at("9am") - 1.day), user: user})}
    let(:tee_time_different_user) {TeeTime.create!({booking_time: today_at("9:20am"), user: second_user})}
    
    before(:each) do
      allow(Time.zone).to receive(:now).and_return(current_time)
    end

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

    it "try to cancel booking for a different user" do
      tee_time_different_user

      expect{
        delete :destroy, id: tee_time_different_user
      }.to change(TeeTime, :count).by(0)
      expect(response).to redirect_to(tee_times_url)
    end
  end


end