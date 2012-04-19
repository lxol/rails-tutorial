# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
  before { @user = User.new( name: "Example User", email: "user@example.com",
                             password: "foobar",
                             password_confirmation: "foobar")}
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before { @user.toggle!(:admin) }
    it { should be_admin }
  end
  describe "When name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  describe "When email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "When name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.save
    end
    it {should_not be_valid}
  end

  describe "When email format is invalid" do
    invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    invalid_addresses.each do |invalid_address|
      before { @user.email = invalid_address }
      it {should_not be_valid }
    end
  end

  describe "When email format is valid" do
    valid_addresses = %w[user@foo.com user@foo.org example.user@foo.org alex+me@aas.com]
    valid_addresses.each do |valid_address|
      before { @user.email = valid_address }
      it {should be_valid }
    end
  end

  describe "when password is not present" do
    before {@user.password = @user.password_confirmation = ""}
    it {should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before {@user.password_confirmation = "mismatch"}
    it {should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before {@user.password_confirmation = nil}
    it {should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email)}
    describe "with valid password" do
      it {should == found_user.authenticate(@user.password)}
    end
    describe "with invalid password" do
      let(:user_for_invalid_password) {
        found_user.authenticate("invalid")
      }
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false}
    end
    describe "with password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5}
      it { should be_invalid }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end
  end
end
