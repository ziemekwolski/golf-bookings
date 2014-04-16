require 'spec_helper'


describe TeeTime do
  let(:user) {users(:default)}
  let(:club) {clubs(:default)}

  def valid_params(options = {})
    {
      user: user,
      booking_time: today_at("9am"),
      club: club
    }.merge(options)
  end

  def is_valid(tee_time)
    tee_time.valid?
    expect(tee_time.errors.full_messages).to eq([])
  end

  describe "Tee Time requires booking time" do
    let(:tee_time) {TeeTime.new}

    it "booking time cannot be nil" do
      expect(tee_time.booking_time).to eq(nil)
      expect(tee_time.valid?).to eq(false)
      expect(tee_time.errors[:booking_time]).to eq(["can't be blank"])
      expect(tee_time.errors[:user]).to eq(["can't be blank"])
      expect(tee_time.errors[:club]).to eq(["can't be blank"])
      expect(tee_time.errors.count).to eq(3)
    end
  end

  describe "Tee times are separated by 20 minutes" do
    let(:tee_time) {TeeTime.new(valid_params)}

    describe "invalid" do
      it "should not accept 1 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 1.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 19 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 19.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 21 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 21.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 39 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 39.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 41 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 41.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 59 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 59.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 1 second passed" do
        tee_time.booking_time = Date.today.to_time + 1.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 20 second passed" do
        tee_time.booking_time = Date.today.to_time + 20.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 40 second passed" do
        tee_time.booking_time = Date.today.to_time + 40.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should not accept 59 second passed" do
        tee_time.booking_time = Date.today.to_time + 59.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end
    end

    describe "valid" do
      it "should accept on hour" do
        tee_time.booking_time = today_at("9am")
        is_valid(tee_time)
      end

      it "should accept 20 minutes passed" do
        tee_time.booking_time = today_at("9:20am")
        is_valid(tee_time)
      end

      it "should accept 40 minutes passed" do
        tee_time.booking_time = today_at("9:40am")
        is_valid(tee_time)
      end

      it "should accpet any hour" do
        tee_time.booking_time = today_at("12:40pm")
        is_valid(tee_time)
      end

    end

  end

  describe "only one slot available per user" do
    let(:selected_booking_time) { (today_at("9am")).to_s(:db) }
    let(:tee_time) {TeeTime.new(valid_params(booking_time: selected_booking_time))}

    before(:each) do
      TeeTime.create!(valid_params(booking_time: selected_booking_time))
    end

    it "already taken" do
      expect(tee_time.valid?).to eq(false)
      expect(tee_time.errors[:booking_time]).to include("has already been taken")
    end

    it "not taken" do
      expect_any_instance_of(TeeTime).to receive(:validates_total_number_of_bookings).and_return(true)
      tee_time.booking_time += 20.minutes
      is_valid(tee_time)
    end
  end

  describe "only available between 9am to 5pm" do
    let(:tee_time) {TeeTime.new(valid_params)}

    # stubbing out the interval time, to test opening hours in isolation
    # incase the interval time ever changes.
    before(:each) do
      allow(tee_time).to receive(:validates_booking_time_interval).and_return(true)
    end

    describe "valid" do
      it "accept booking at 9am" do
        tee_time.booking_time = today_at("9am")
        is_valid(tee_time)
      end
      it "accept booking at 9:00:01am" do
        tee_time.booking_time = today_at("9:00:01am")
        is_valid(tee_time)
      end
      it "accept booking at 4:59:59pm" do
        tee_time.booking_time = today_at("4:59:59pm")
        is_valid(tee_time)
      end
    end

    describe "invalid" do
      it "not accpet booking at 8:59:59am" do
        tee_time.booking_time = today_at("8:59:59am")
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must be between 9am and 5pm"])
      end

      it "not accpet booking at 5pm" do
        tee_time.booking_time = today_at("5pm")
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must be between 9am and 5pm"])
      end

      it "not accpet booking at 5:00:01pm" do
        tee_time.booking_time = today_at("5:00:01pm")
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must be between 9am and 5pm"])
      end

      it "not accpet booking at 9:00pm" do
        tee_time.booking_time = today_at("9pm")
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must be between 9am and 5pm"])
      end

      it "not accpet booking at 9:00:01pm" do
        tee_time.booking_time = today_at("9:00:01pm")
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must be between 9am and 5pm"])
      end

      it "not accpet booking at 4:59:59am" do
        tee_time.booking_time = today_at("4:59:59am")
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must be between 9am and 5pm"])
      end
    end
  end

  describe "validates_total_number_of_bookings" do
    let(:current_time) {Time.zone.today.to_time}
    let(:first_tee_time) {TeeTime.new(valid_params(booking_time: (today_at("9am"))))}
    let(:second_tee_time) {TeeTime.new(valid_params(booking_time: (today_at("9:20am"))))}
    let(:third_tee_time) {TeeTime.new(valid_params(booking_time: (today_at("9:40am"))))}

    before(:each) do
      allow(Time.zone).to receive(:now).and_return(current_time)
    end

    it "user can only create two bookings" do
      first_tee_time.save!
      second_tee_time.save!
      expect(user.tee_times.count).to eq(3)
      expect(user.tee_times.in_present.count).to eq(2)
      expect(third_tee_time.valid?).to eq(false)
      expect(third_tee_time.errors[:booking_time]).to include("Users can only have two bookings")
    end
  end


  describe "list available times" do
    
    # output is in this format: 
    # ["09:00 AM", "09:20 AM", "09:40 AM", "10:00 AM", ... "04:20 PM", "04:40 PM"]
    let(:all_available_times) {
      start_time = today_at("9am")
      end_time = today_at("5pm")
      counter_time = start_time
      output = []
      loop do
        output << counter_time.strftime("%I:%M %p")
        counter_time += 20.minutes
        break if counter_time >= end_time
      end 
      output
    }

    describe "valid date" do
      it "list times in an array" do
        expect(TeeTime.booked_times_by_time(Time.zone.today)).to eq({})
      end

      it "list times in an array, exclude booked" do
        first = TeeTime.create!(valid_params(booking_time: today_at("9am")))
        second = TeeTime.new(valid_params(booking_time: today_at("9:20am")))
        expect(second).to receive(:validates_total_number_of_bookings).and_return(true)
        second.save!

        expect(TeeTime.booked_times_by_time(Time.zone.today)).to eq({"09:00 AM" => first, "09:20 AM" => second})
      end

    end

    describe "invalid date" do

      it "invalid date should raise error" do
        expect{TeeTime.booked_times_by_time(nil)}.to raise_error(ArgumentError)
      end

      it "invalid out of range date" do
        expect{TeeTime.booked_times_by_time("2012-44-40")}.to raise_error(ArgumentError)
      end
    end
  end


  describe "scopes" do

    describe "in_present" do
      let(:current_time) {Time.zone.today.to_time}

      before(:each) do
        expect_any_instance_of(TeeTime).to receive(:validates_booking_time_interval).and_return(true)
        expect_any_instance_of(TeeTime).to receive(:validates_open_hours).and_return(true)
        allow(Time.zone).to receive(:now).and_return(current_time)
      end

      it "one second in the past" do
        record = TeeTime.create!(valid_params(booking_time: Time.zone.now - 1.second))
        expect(TeeTime.in_present).to_not include(record)
      end

      it "at current time" do
        record = TeeTime.create!(valid_params(booking_time: Time.zone.now))
        expect(TeeTime.in_present).to include(record)
      end

      it "one second in the future" do
        record = TeeTime.create!(valid_params(booking_time: Time.zone.now))
        expect(TeeTime.in_present).to include(record)
      end

    end

    describe "within_date" do
      before(:each) do
        expect_any_instance_of(TeeTime).to receive(:validates_booking_time_interval).and_return(true)
        expect_any_instance_of(TeeTime).to receive(:validates_open_hours).and_return(true)
      end

      it "include first record of the day" do
        record = TeeTime.create!(valid_params(booking_time: Time.zone.parse("2014-04-01").beginning_of_day))

        expect(TeeTime.within_date(Time.zone.parse("2014-04-01"))).to eq([record])
        expect(TeeTime.within_date(Time.zone.parse("2014-03-31"))).to eq([])
        expect(TeeTime.within_date(Time.zone.parse("2014-04-02"))).to eq([])
      end

      it "include last record of the day" do
        record = TeeTime.create!(valid_params(booking_time: Time.zone.parse("2014-04-01").end_of_day))

        expect(TeeTime.within_date(Time.zone.parse("2014-04-01"))).to eq([record])
        expect(TeeTime.within_date(Time.zone.parse("2014-03-31"))).to eq([])
        expect(TeeTime.within_date(Time.zone.parse("2014-04-02"))).to eq([])
      end
    end

    describe "exclude_hours_before" do
      let(:current_time) {Time.zone.today}
      let(:tee_time) {TeeTime.new(valid_params(booking_time: Time.zone.now))}
      
      before(:each) do
        expect_any_instance_of(TeeTime).to receive(:validates_booking_time_interval).and_return(true)
        expect_any_instance_of(TeeTime).to receive(:validates_open_hours).and_return(true)
        allow(Time.zone).to receive(:now).and_return(current_time)
      end

      it "should not list if happening 59 mintues 59 second" do
        tee_time.booking_time += (59.minute + 59.seconds)
        tee_time.save!

        expect(TeeTime.exclude_less_then_hours_before(1.hour)).to_not include(tee_time)
      end

      it "should not list if happening 1hour ago" do
        tee_time.booking_time += (1.hour)
        tee_time.save!

        expect(TeeTime.exclude_less_then_hours_before(1.hour)).to include(tee_time)
      end

      it "should not list if happening 1 hour 1 second" do
        tee_time.booking_time += (1.hour + 1.second)
        tee_time.save!

        expect(TeeTime.exclude_less_then_hours_before(1.hour)).to include(tee_time)
      end
    end

    describe "by_booking_times" do
      let(:tee_time) {tee_times(:default)}

      it "should find by booking_time" do
        expect(TeeTime.by_booking_times(tee_time.booking_time).first).to eq(tee_time)
      end
    end
  end
end
