require 'spec_helper'
require 'rails_helper'

feature "the sign up process" do

  scenario "it has a user page" do
    visit "users/new"

    expect(page).to have_content('Sign Up')
  end

  scenario "sign up has username field" do
    visit "users/new"

    expect(page).to have_content('Username')
  end

  scenario "sign up has a password field" do
    visit "users/new"

    expect(page).to have_content('Password')
  end

  scenario "expect signing up to redirect to goals index" do
    visit "users/new"

    fill_in('Username', with: 'Justoon')
    fill_in('Password', with: 'Nootsuj')
    click_button('Submit')
    expect(page).to have_content('Goals Index')
  end

  scenario "expect to return error for blank username" do
    visit "users/new"

    fill_in('Password', with: 'naaaacaaaacaaaa')
    click_button('Submit')
    expect(page).to have_content('Username can\'t be blank')
  end

  scenario "expect to return error for blank password" do
    visit "users/new"

    fill_in('Username', with: 'HUNNYPOOH')
    click_button('Submit')
    expect(page).to have_content('Password is too short')
  end
end

feature "the login process" do
  scenario "it has a sign up page" do
    visit "session/new"

    expect(page).to have_content('Log In')
  end

  scenario "it takes username and password" do
    visit "session/new"

    expect(page).to have_content('Password')
    expect(page).to have_content('Username')
  end

  scenario "expect log in to redirect to goals index" do
    sign_up_as_justoon
    logout_user

    fill_in('Username', with: 'justoon')
    fill_in('Password', with: 'nootsuj')
    click_button('Submit')

    expect(page).to have_content('Goals Index')
  end

  scenario "to return error for blank username or password" do
    visit "session/new"

    click_button('Submit')

    expect(page).to have_content("Username or Password was too smelly.")
  end
end

feature "the logout process" do

  scenario "it redirects to new session page" do
    sign_up_as_justoon

    logout_user

    expect(page).to have_content('Log In')
  end
end
