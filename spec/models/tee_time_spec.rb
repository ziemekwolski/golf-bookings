require 'spec_helper'

describe TeeTime do
  describe "Tee times are separated by 20 minutes" do
    let(:tee_time) {TeeTime.new}

    describe "invalid" do
      it "should accept 1 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 1.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 19 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 19.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 21 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 21.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 39 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 21.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 41 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 21.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 59 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 1.minutes
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 1 second passed" do
        tee_time.booking_time = Date.today.to_time + 1.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 20 second passed" do
        tee_time.booking_time = Date.today.to_time + 20.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 40 second passed" do
        tee_time.booking_time = Date.today.to_time + 40.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end

      it "should accept 59 second passed" do
        tee_time.booking_time = Date.today.to_time + 59.second
        expect(tee_time.valid?).to eq(false)
        expect(tee_time.errors[:booking_time]).to eq(["must in intervals of 20"])
      end
    end

    describe "valid" do
      it "should accept on hour" do
        tee_time.booking_time = Date.today.to_time
        expect(tee_time.valid?).to eq(true)
      end

      it "should accept 20 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 20.minutes
        expect(tee_time.valid?).to eq(true)
      end

      it "should accept 40 minutes passed" do
        tee_time.booking_time = Date.today.to_time + 40.minutes
        expect(tee_time.valid?).to eq(true)
      end

      it "should accpet any hour" do
        tee_time.booking_time = Date.today.to_time + 3.hours + 40.minutes
        expect(tee_time.valid?).to eq(true)
      end

    end

  end

end
