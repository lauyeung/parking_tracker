require 'spec_helper'

feature "parker registers a parking spot", %Q{
As a parker
I want to register my spot with my name
So that the parking company can identify my car} do


# Acceptance Criteria:

# * I must specify a first name, last name, email, and parking spot number
# * I must enter a valid parking spot number (the lot has spots identified as numbers 1-60)
# * I must enter a valid email
# * I must enter a parking spot number that has not already been taken
# * I can optionally include a photo of my car as part of my parking registration
# * If I supply a photo, it must be a jpg, png, or gif
# * If I supply a photo, it cannot exceed 5MB

  scenario "I specify valid information" do
    prev_count = Registration.count
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: 'sjones@sam.com'
    fill_in 'Parking spot', with: '1'
    attach_file 'Car Photo', Rails.root.join('spec/file_fixtures/valid_car_image.jpg')
    click_button 'Submit'
    expect(page).to have_content("Thanks for registering your car!")
    expect(Registration.count).to eql(prev_count + 1)
    expect(Registration.last.car_photo.url).to be_present
  end

   scenario "I specify invalid information" do
    prev_count = Registration.count
    visit '/'
    click_button 'Submit'
    expect(page).to have_content("can't be blank")
    expect(Registration.count).to eql(prev_count)
  end


  scenario "I try to register a spot that has already been taken" do
    FactoryGirl.create(:registration)
    prev_count = Registration.count
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: 'sjones@sam.com'
    fill_in 'Parking spot', with: '1'
    click_button 'Submit'
    expect(page).to have_content("has already been taken")
    expect(Registration.count).to eql(prev_count)
  end

  scenario "I can register a spot today that was taken yesterday" do
    prev_count = Registration.count
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: 'sjones@sam.com'
    fill_in 'Parking spot', with: '1'
    click_button 'Submit'
    expect(page).to have_content("Thanks for registering your car!")
    expect(Registration.count).to eql(prev_count + 1)
  end

end
