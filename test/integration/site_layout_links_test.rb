require 'test_helper'

class SiteLayoutLinksTest < ActionDispatch::IntegrationTest
  test "sign in page links" do
    get root_path
    assert_template 'devise/sessions/new'
    assert_select "a[href=?]", root_path, text: "Feed Reader"
    assert_select "a[href=?]", new_user_session_path, text: "Sign In"
    assert_select "a[href=?]", new_user_registration_path, text: "Sign up"
    assert_select "a[href=?]", new_user_password_path, text: "Forgot your password?"
  end

  test "layout links after sign in" do
    get root_path 
    assert_template 'devise/sessions/new'
    # post new_user_session
    # assert_select "a[href=?]", root_path, count: 2
    # assert_select "a[href=?]", feeds_path
  end
end
