require 'spec_helper'

describe TeeTime do

  def is_valid(tee_time)
    tee_time.valid?
    expect(tee_time.errors.full_messages).to eq([])
  end

  def today_at(time)
    Time.zone.parse("#{Time.zone.today} #{time}")
  end

  describe "Tee Time requires booking time" do
    let(:tee_time) {TeeTime.new}

    it "booking time cannot be nil" do
      expect(tee_time.booking_time).to eq(nil)
      expect(tee_time.valid?).to eq(false)
      expect(tee_time.errors[:booking_time]).to eq(["can't be blank"])
      expect(tee_time.errors.count).to eq(1)
    end
  end

  describe "Tee times are separated by 20 minutes" do
    let(:tee_time) {TeeTime.new}

    describe "invalid" do
      it "should accept 1 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 1.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 19 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 19.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 21 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 21.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 39 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 21.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 41 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 21.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 59 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 1.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 1 second passed" do
        tee_time.booking_time = Date.today.to_time + 1.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 20 second passed" do
        tee_time.booking_time = Date.today.to_time + 20.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 40 second passed" do
        tee_time.booking_time = Date.today.to_time + 40.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to include("must in intervals of 20")
      end

      it "should accept 59 second passed" do
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
    let(:tee_time) {TeeTime.new(booking_time: selected_booking_time)}

    before(:each) do
      TeeTime.create!(booking_time: selected_booking_time)
    end

    it "already taken" do
      expect(tee_time.valid?).to eq(false)
      expect(tee_time.errors[:booking_time]).to eq(["has already been taken"])
    end

    it "not taken" do
      tee_time.booking_time += 20.minutes
      is_valid(tee_time)
    end
  end

  describe "only available between 9am to 5pm" do
    let(:tee_time) {TeeTime.new}

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
        first = TeeTime.create!(booking_time: today_at("9am"))
        second = TeeTime.create!(booking_time: today_at("9:20am"))

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
    describe "within_date" do
      before(:each) do
        expect_any_instance_of(TeeTime).to receive(:validates_booking_time_interval).and_return(true)
        expect_any_instance_of(TeeTime).to receive(:validates_open_hours).and_return(true)
      end

      it "include first record of the day" do
        record = TeeTime.create!(booking_time: Time.zone.parse("2014-04-01").beginning_of_day)

        expect(TeeTime.within_date(Time.zone.parse("2014-04-01"))).to eq([record])
        expect(TeeTime.within_date(Time.zone.parse("2014-03-31"))).to eq([])
        expect(TeeTime.within_date(Time.zone.parse("2014-04-02"))).to eq([])
      end

      it "include last record of the day" do
        record = TeeTime.create!(booking_time: Time.zone.parse("2014-04-01").end_of_day)

        expect(TeeTime.within_date(Time.zone.parse("2014-04-01"))).to eq([record])
        expect(TeeTime.within_date(Time.zone.parse("2014-03-31"))).to eq([])
        expect(TeeTime.within_date(Time.zone.parse("2014-04-02"))).to eq([])
      end
    end
  end
end
