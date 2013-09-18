require 'spec_helper'

feature "user finds out who their neighbors are", %Q{
As a parker
I want to see my two neighbors
So that I can get to know them better} do

# Acceptance Criteria:

# * After checking in, if I have a neighbor in a spot 1 below me,
# or one above me, I am informed of their name and what spot number they are currently in
# * If I do not have anyone parking next to me, I am told that I have no current neighbors

  scenario 'no neighbors present' do
    create_registration_for(5)
    expect(page).to have_content('You have no neighbors')
  end

  scenario "I have neighbors in the spots below and above me" do
    FactoryGirl.create(:registration, first_name: 'Hercules')
    FactoryGirl.create(:registration, parking_spot_number: 3)
    visit '/'
    fill_in 'First name', with: 'Shazam'
    fill_in 'Last name', with: 'Blam'
    fill_in 'Email', with: 'sblam@ham.com'
    fill_in 'Parking spot', with: '2'
    click_button 'Submit'
    expect(page).to have_content("Spot 1 is occupied by Hercules Hello.")
    expect(page).to have_content("Spot 3 is occupied by Joe Hello.")
    expect(page).to_not have_content("You have no neighbors.")
  end

  scenario 'a neighbor with a spot one less than me' do
    neighbor_first_name = 'Sam'
    FactoryGirl.create(:registration,
      first_name: neighbor_first_name,
      parking_spot_number: 4)
    create_registration_for(5)
    expect(page).to have_content(neighbor_first_name)
  end

  scenario 'a neighbor with a spot one more than me' do
    FactoryGirl.create(:registration, parking_spot_number: 26)
    neighbor_first_name = 'Jack'
    FactoryGirl.create(:registration,
      first_name: neighbor_first_name,
      parking_spot_number: 25)
    create_registration_for(24)
    expect(page).to have_content(neighbor_first_name)
  end

  scenario 'a neighbor that is not in immediate proximity' do
    FactoryGirl.create(:registration, parking_spot_number: 29)
    FactoryGirl.create(:registration, parking_spot_number: 20)
    create_registration_for(24)
    expect(page).to have_content('You have no neighbors')
  end

  include ParkingRegistrationTestHelpers
end
