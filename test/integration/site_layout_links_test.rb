require 'test_helper'

class SiteLayoutLinksTest < ActionDispatch::IntegrationTest

  test "default home page links" do
    get root_path
    assert_select "h1", text: "Feed Reader"
    assert_select "a[href=?]", new_user_session_path, text: "Sign In"
    assert_select "a[href=?]", new_user_registration_path, text: "Sign Up"
  end

  test "navbar links after sign in" do
    @user = users(:chris)
    post user_session_path
    assert_select "a[href=?]", root_path, text: "Feed Reader"
    assert_select "a[href=?]", new_user_session_path, text: "Sign In"
    assert_select "a[href=?]", new_user_registration_path, text: "Sign up"
    assert_select "a[href=?]", new_user_password_path, text: "Forgot your password?"
  end

end
