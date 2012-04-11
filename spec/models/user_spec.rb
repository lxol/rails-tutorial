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

end
