require 'spec_helper'

feature "user gets parking history", %Q{
  As a parker
  I want to see a list of my parking activity
  So that I can see where I've parked over time
} do

# Acceptance Criteria:
# * When checking in, if I've previously checked in with the same email,
#   I am given the option to see parking activity
# * If I opt to see parking activity, I am shown all of my check-ins sorted in
#   reverse chronological order.
#   I can see the spot number and the day and time I checked in.
# * If I have not previously checked in, I do not have the option to see parking activity

  scenario 'user has not checked in previously and has no parking activity link' do
    email = 'sjones@sam.com'
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: email
    fill_in 'Parking spot', with: '1'
    click_button 'Submit'
    expect(page).to_not have_content("View Parking History")
  end

  scenario 'user has checked in previously and sees parking activity' do
    email = 'user@email.com'
    first_parking_spot = '1'
    second_result = FactoryGirl.create(:registration, parking_spot_number: 2, email: email, parked_on: Date.new(2013, 9, 15), created_at: Time.new(2013, 9, 15, 9, 30, 0, "-04:00"))
    third_result = FactoryGirl.create(:registration, parking_spot_number: 3, email: email, parked_on: Date.new(2013, 7, 31), created_at: Time.new(2013, 7, 31, 9, 30, 0, "-04:00"))
    visit '/'
    fill_in 'First name', with: 'Sam'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: email
    fill_in 'Parking spot', with: first_parking_spot
    click_button 'Submit'
    click_link 'View Parking History'
    expect(page).to have_content(first_parking_spot)
    expect(page).to have_content(second_result.parking_spot_number)
    expect(page).to have_content(third_result.parking_spot_number)
    # first_parking_spot.should appear_before(second_result.parking_spot_number)
    # second_result.first_name.should appear_before(third_result.parking_spot_number)
  end

end
