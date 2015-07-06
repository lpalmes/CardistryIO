module Features
  def sign_up(options = {})
    email = options.fetch(:email, "kevin@example.com")
    username = options.fetch(:username, "visualmadness")
    password = options.fetch(:password, "passwordlol")
    first_name = options.fetch(:first_name, "Kevin")
    last_name = options.fetch(:last_name, "Ho")

    visit root_path
    click_link "Sign up"
    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Username", with: username
    fill_in "First name", with: first_name
    fill_in "Last name", with: last_name
    click_button "Sign up"
  end
end
