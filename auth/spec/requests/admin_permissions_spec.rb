require 'spec_helper'

describe "Admin Permissions" do
  context "admin is restricted from accessing orders" do
    before(:each) do
      user = Factory(:admin_user, :email => "admin@person.com", :password => "password", :password_confirmation => "password")
      Spree::Ability.register_ability(AbilityDecorator)
      visit login_path
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => user.password
      click_button "Log In"
    end

    it "should not be able to list orders" do
      visit spree_core.admin_orders_path
      page.should have_content("Authorization Failure")
    end

    it "should not be able to edit orders" do
      Factory(:order, :number => "R123")
      visit spree_core.edit_admin_order_path("R123")
      page.should have_content("Authorization Failure")
    end

    it "should not be able to view an order" do
      Factory(:order, :number => "R123")
      visit spree_core.admin_order_path("R123")
      page.should have_content("Authorization Failure")
    end
  end
end
