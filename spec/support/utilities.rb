include ApplicationHelper

def full_title(page_title = '', override = false)
  base_title = override.to_s == "true" ? "" : "Open Source Story"
  if page_title.empty?
    base_title.html_safe
  else
    if base_title.empty?
      "#{page_title}".html_safe
    else
      "#{base_title} - #{page_title}".html_safe
    end
  end
end

def sign_in(user)
  visit signin_path
  fill_in "Email",      with: user.email
  fill_in "Password",   with: user.password
  click_button "Sign in"

  cookies[:token] = user.remember
end

def valid_signin(user)
  fill_in "Email",      with: user.email
  fill_in "Password",   with: user.password
  click_button "Sign in"
end

def log_out
  click_link "Sign out"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end