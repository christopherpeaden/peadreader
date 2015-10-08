module RequestHelpers 
                                     
  def sign_in_valid_user(user)
    visit "/users/sign_in"
    expect(page).to have_selector("h2", "Log in")
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_selector('p.notice', 'success')
  end                                
end                                  

