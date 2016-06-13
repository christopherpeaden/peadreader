module RequestHelpers 
                                     
  def sign_in_valid_user(user)
    visit "/users/sign_in"
    expect(page).to have_link("Sign In")
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign In"
    expect(page).to have_selector('div.alert', text: "Signed in successfully.")
  end                                
end                                  

