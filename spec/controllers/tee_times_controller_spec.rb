require 'spec_helper'

describe TeeTimesController do

  let(:user) {users(:default)}
  let(:club) {clubs(:default)}

  def valid_params(options = {})
    {
      user: user,
      booking_time: today_at("9am"),
      club: club
    }.merge(options)
  end


  before(:each) do
    login_user(user)
  end

  describe "index" do
    describe "valid" do
      it "index" do
        get :index, club_id: club
        expect(response).to be_success
      end

      it "index with date range" do
        get :index, club_id: club, date: "2014-04-15"
        expect(assigns(:selected_date)).to eq(Time.zone.parse("2014-04-15").to_date)
        expect(response).to be_success
      end
    end

    describe "invalid" do
      it "invalid date range" do
        get :index, club_id: club, date: "2014-44-15"
        expect(response).to redirect_to(club_tee_times_url(club))
      end

      it "invalid date range" do
        get :index, club_id: club, date: ""

        expect(assigns(:selected_date)).to eq(Time.zone.today)
        expect(response).to be_success
      end
    end
  end

  describe "create booking" do
    it "create" do 
      expect{
        post :create, club_id: club, tee_time: {booking_time: today_at("9:20am")}
      }.to change(TeeTime, :count).by(1)
      expect(assigns(:tee_time).user).to eq(user)
      expect(response).to redirect_to(club_tee_times_url(club_id: club, date:today_at("9:20am").to_date))
    end

    it "invalid create" do
      expect{
        post :create, club_id: club, tee_time: {booking_time: ""}
      }.to change(TeeTime, :count).by(0)
      expect(response).to redirect_to(club_tee_times_url(club))
    end
  end

  describe "Cancel booking" do
    let(:current_time) {Time.zone.today.to_time}
    let(:second_user) {users(:second)}
    let(:tee_time) {TeeTime.create!(valid_params({booking_time: today_at("9am"), user: user}))}
    let(:past_one) {TeeTime.create!(valid_params({booking_time: (today_at("9am") - 1.day), user: user}))}
    let(:tee_time_different_user) {TeeTime.create!(valid_params({booking_time: today_at("9:20am"), user: second_user}))}
    
    before(:each) do
      allow(Time.zone).to receive(:now).and_return(current_time)
    end

    it "valid cancel" do
      tee_time

      expect{
        delete :destroy, club_id: club, id: tee_time
      }.to change(TeeTime, :count).by(-1)
      expect(response).to redirect_to(club_tee_times_url(club_id: club, date: tee_time.booking_time.to_date))
    end

    it "invalid cancel" do
      past_one

      expect{
        delete :destroy, club_id: club, id: past_one
      }.to change(TeeTime, :count).by(0)
      expect(response).to redirect_to(club_tee_times_url(club))
    end

    it "try to cancel booking for a different user" do
      tee_time_different_user

      expect{
        delete :destroy, club_id: club, id: tee_time_different_user
      }.to change(TeeTime, :count).by(0)
      expect(response).to redirect_to(club_tee_times_url(club))
    end
  end


end