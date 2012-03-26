require 'spec_helper'

describe "Static pages" do

  describe "Home Page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      page.should have_content('Sample App')
    end
  end
  describe "Help page" do

    it "Should have a content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end

  describe "About page" do

    it "Should have a content 'About'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end
  end

end
