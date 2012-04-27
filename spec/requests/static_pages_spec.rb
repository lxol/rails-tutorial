require 'spec_helper'

describe "Static pages" do
  it "Should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('Home')
    click_link "Sign up"
    page.should have_selector 'title', text: full_title('Sign up')

  end

  subject { page }
  describe "Home Page" do
    before {visit root_path}
    it { should have_content('Sample App')}
    it { should have_selector('title', :text => full_title('Home'))}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          user.feed.each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end
      end
    end
  end
  describe "Help page" do
    before {visit help_path}
    it {should have_content('Help')}
    it {should have_selector('title', :text => full_title('Help'))}
  end
  describe "About page" do
    before {visit about_path}
    it {should have_content('About Us')}
    it {should have_selector('title', :text => full_title('About'))}
  end
  describe "Contact page" do
    before {visit contact_path}
    it {should have_selector('h1', text: 'Contact')}
    it {page.should have_selector('title',:text => full_title('Contact'))}
  end
end
