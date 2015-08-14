require 'test_helper'

class UserSignUpTest < ActionDispatch::IntegrationTest
  test "sign up failure" do
    get new_user_registration_path
    post user_registration_path, user: { email: 'whicheverpeady@gmail.com', password: '12345678', password_confirmation: '' }
    assert_template 'devise/registrations/new'
  end

#  test 'sign up success' do
#    get new_user_registration_path
#    post user_registration_path, user: { email: 'boliver@gmail.com', password: '12345678', password_confirmation: '12345678' }
#    assert_redirected_to 'devise/sessions/new'
#  end
end
