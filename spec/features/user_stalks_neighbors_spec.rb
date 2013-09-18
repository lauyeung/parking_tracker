require 'spec_helper'

feature "user finds out who their neighbors are", %Q{
As a parker
I want to see my two neighbors
So that I can get to know them better} do

# Acceptance Criteria:

# * After checking in, if I have a neighbor in a spot 1 below me,
# or one above me, I am informed of their name and what spot number they are currently in
# * If I do not have anyone parking next to me, I am told that I have no current neighbors

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

  scenario "I have no neighbors in either spot below or above me" do
    visit '/'
    fill_in 'First name', with: 'Shazam'
    fill_in 'Last name', with: 'Blam'
    fill_in 'Email', with: 'sblam@ham.com'
    fill_in 'Parking spot', with: '22'
    click_button 'Submit'
    expect(page).to have_content("You have no neighbors.")
  end

  # scenario "I have one neighbor in the spot below me" do
  #   FactoryGirl.create(:registration)
  #   visit '/'
  #   fill_in 'First name', with: 'Shazam'
  #   fill_in 'Last name', with: 'Blam'
  #   fill_in 'Email', with: 'sblam@ham.com'
  #   fill_in 'Parking spot', with: '2'
  #   click_button 'Submit'
  #   expect(page).to have_content("Spot 1 is occupied by Joe Hello.")
  # end

  # scenario "I have one neighbor in the spot above me" do
  #   FactoryGirl.create(:registration, parking_spot_number: 3)
  #   visit '/'
  #   fill_in 'First name', with: 'Shazam'
  #   fill_in 'Last name', with: 'Blam'
  #   fill_in 'Email', with: 'sblam@ham.com'
  #   fill_in 'Parking spot', with: '2'
  #   click_button 'Submit'
  #   expect(page).to have_content("Spot 3 is occupied by Joe Hello.")
  # end

end
