require 'spec_helper'

feature "parker registers a parking spot", %Q{
As a parker
I want to register my spot with my name
So that the parking company can identify my car} do


# Acceptance Criteria:

# * I must specify a first name, last name, email, and parking spot number
# * I must enter a valid parking spot number (the lot has spots identified as numbers 1-60)
# * I must enter a valid email

  scenario "I specify valid information" do
    prev_count = Registration.count
    visit '/'
    click_link 'Register'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: 'sjones@sam.com'
    fill_in 'Parking spot', with: '1'
    click_button 'Submit'
    expect(page).to have_content("Thanks for registering your car!")
    expect(Registration.count).to eql(prev_count + 1)
  end

   scenario "I specify invalid information" do
    prev_count = Registration.count
    visit '/'
    click_link 'Register'
    click_button 'Submit'
    expect(page).to have_content("can't be blank")
    expect(Registration.count).to eql(prev_count)
  end

end
