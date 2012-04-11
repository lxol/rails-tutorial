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
  before { @user = User.new( name: "Example User", email: "user@example.com")}
  subject { @user }
  it { should respond_to(:name) }
  it { should respond_to(:email) }

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

end
