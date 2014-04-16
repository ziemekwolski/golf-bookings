require 'spec_helper'

describe Club do
  def valid_params
    {
      name: "Super Green Grass"
    }
  end

  it "should create a club" do
    expect{
      Club.create(valid_params)  
    }.to change{Club.count}.by(1)
  end

  it "should error out" do
    club = nil
    expect{
      club = Club.create({})  
    }.to change{Club.count}.by(0)
    expect(club.errors[:name]).to include("can't be blank")
  end


end
