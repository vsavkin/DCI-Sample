require 'spec_helper'

feature "Authenticating user", js: true do
  scenario "Sign up" do
    visit root_path
    click_link "Sign in"
    click_link "Sign up"

    within("#new_user") do
      fill_in "user_email", :with => "mail@mail.com"
      fill_in "user_name", :with => "username"
      fill_in "user_password", :with => "123456"
      fill_in "user_password_confirmation", :with => "123456"
      click_button "Sign up"
    end

    page.should have_content(I18n.t("devise.registrations.signed_up"))
  end

  scenario "Sign in" do
    user = ObjectMother.create_user

    visit root_path
    click_link "Sign in"
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    click_button "Sign in"

    page.should have_content(I18n.t "devise.sessions.signed_in")
  end
end
