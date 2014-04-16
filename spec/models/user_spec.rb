require 'spec_helper'

describe User do
  let(:user) {users(:default)}

  def valid_params
    {
      name: "bob",
      email: "bob@example.com",
      password: "test",
      password_confirmation: "test"
    }
  end

  it "should create a user" do
    expect{
      User.create(valid_params)  
    }.to change{User.count}.by(1)
  end

  it "should error on invalid user" do
    expect{
      user = User.create({})
      user.errors[:name].should eq(["can't be blank"])
      user.errors[:email].should eq(["can't be blank", "is not formatted properly"])
      user.errors.keys.should eq([:name, :email, :password])
    }.to change{User.count}.by(0)
  end


  it "should require password confirmation if password is entered" do
    user.password = "new"
    user.password_confirmation = ""
    user.valid?
    user.errors.full_messages.should eq(["Password confirmation doesn't match Password"])
  end


end
