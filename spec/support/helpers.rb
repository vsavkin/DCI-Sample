def do_login! user
  visit new_user_session_path
  click_link "Sign in"
  fill_in "user_email", :with => user.email
  fill_in "user_password", :with => user.password
  click_button "Sign in"
end
