require 'spec_helper'
require 'rails_helper'

feature "index page" do

  scenario "has the text Index" do
    sign_up_as_justoon

    expect(page).to have_content("Index")
  end

  scenario "cannot visit site if not signed in" do
    visit goals_url

    expect(page).to have_content("Log In")
  end

  scenario "has link to create goal" do
    sign_up_as_justoon

    expect(page).to have_content("Create Goal")
  end
end

feature "goal creation page" do

  before(:each) do
    sign_up_as_justoon
    click_link('Create Goal')
  end

  scenario "has shit" do
    expect(page).to have_content("Create a Goal")
  end

  scenario "displays errors" do
    click_button("Submit")

    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Content can't be blank")
    expect(page).to have_content("Access can't be blank")
  end

  scenario "has title, content, and lots of other stuff" do
    expect(page).to have_content("Title")
    expect(page).to have_content("Content")
    expect(page).to have_content("Access")
  end

  scenario "makes goals" do
    fill_in("Title", with: "Piss of Justoon")
    fill_in("Content", with: "Goat's blood for Justice")
    choose("PubicHair")
    click_button("Submit")

    expect(page).to have_content("Piss of Justoon")
    expect(page).to have_content("Goat's blood for Justice")
  end
end

feature "goal show page" do
  before(:each) do
    sign_up_as_justoon
    create_piss_goal
  end

  scenario "has delete buttooon" do
    click_button("Delete Goal")

    expect(page).to have_content("Goals Index")
    expect(page).to have_no_content("Piss of Justoon")
  end

  scenario "has edit buuuton" do
    click_button("Edit Goal")
    fill_in("Title", with: "Poss af Jastuun")
    click_button("Submit")

    expect(page).to have_content("Poss af Jastuun")
  end
end


feature "goal edit page" do
  before(:each) do
    sign_up_as_justoon
    create_piss_goal
    click_button("Edit Goal")
  end

  scenario "has shit" do
    expect(page).to have_content("Title")
    expect(page).to have_content("Content")
    expect(page).to have_content("Access")
  end

  scenario "returns to show page" do
    click_button("Submit")

    expect(page).to have_content("Piss of Justoon")
  end
end
