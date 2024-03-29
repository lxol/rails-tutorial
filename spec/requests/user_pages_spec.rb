require 'spec_helper'

describe "UserPages" do
  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }

    describe "pagination" do
      before(:all) {30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_link('Next') }
      it { should have_link('2') }

      let(:first_page) { User.paginate(page: 1) }
      let(:second_page) { User.paginate(page: 2) }
      it "should list the first page of users" do
        first_page.each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
      it "should not list the second page of users" do
        second_page.each do |user|
          page.should_not have_selector('li', text: user.name)
        end
      end

      it {should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }

        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end

        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end

  end

  before {visit signup_path}
  it {should have_selector('h1', text:  'Sign up')}
  it {should have_selector('title', text: full_title('Sign up'))}

  describe "signup" do
    before { visit signup_path }
    describe "with invalid information" do
      it "should not create a user" do
        expect {click_button "Create my account" }.not_to change(User, :count)
      end
      describe "after saving the user" do
        before {click_button "Create my account"}
        it { should have_selector('title', text: "Sign up") }
        it { should have_selector('div.alert.alert-error', text: 'error') }
      end

    end
    describe "with valid information" do
      before do
        fill_in "Name",  with: "Example User"
        fill_in "Email",  with: "user@example.com"
        fill_in "Password",  with: "foobar"
        fill_in "Confirm Password",  with: "foobar"
      end
      it "should create user" do
        expect do
          click_button "Create my account"
        end.to change(User, :count).by(1)
      end
      describe "after saving the user" do
        before {click_button "Create my account"}
        let(:user) {User.find_by_email('user@example.com') }
        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end
    describe "page"  do
      it {should have_selector('h1', text: "Update your profile") }
      it {should have_selector('title', text: "Edit user") }
      it {should have_link('change', href: "http://gravatar.com/emails") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end

    describe "with invalid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name", with: new_name
        fill_in "Email", with: new_email
        fill_in "Password", with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end
      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', :href => signout_path) }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end

describe "profile page" do
  # Code to make a user variable
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }

  before { visit user_path(user) }

  it {should have_selector('h1', text: user.name) }
  it {should have_selector('title', text: user.name) }
  it { should have_content(m1.content) }
  it { should have_content(user.microposts.count) }

  describe "with one micropost" do
    it "should have selector " do
      should have_selector('h3', text: /1 Micropost\b/)
    end
  end

  describe "with two micropsts" do
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
    before { visit user_path(user) }
    it "should have selector" do
      should have_selector('h3', text: /2 Microposts/)
    end
    it { should have_content(m2.content) }
  end

  describe "with micropost pagination" do
    before do
      30.times { FactoryGirl.create(:micropost, user: user) }
      visit user_path(user)
    end
    after { Micropost.delete_all }

    let(:first_page) {user.microposts.paginate(page: 1) }
    let(:second_page) {user.microposts.paginate(page: 2) }

    it { should have_link('Next') }
    it { should have_link('2') }

    it "should list the first page of microposts" do
      first_page.each do |each_micropost|
        page.should have_selector('li', text: each_micropost.content)
      end
    end
    it "should not list the second page of micropsts" do
      second_page.each do |each_micropost|
        page.should_not have_selector('li', text: each_micropost.content)
      end
    end
  end

end
