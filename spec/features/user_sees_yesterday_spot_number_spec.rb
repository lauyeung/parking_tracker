require 'spec_helper'

feature "user sees yesterday parking spot information", %Q{
  As a parker
  I want to know what spot I parked in yesterday
  So that I can determine if I'm parking in the same spot
} do

# Acceptance Criteria:
# * If I parked yesterday, the system tells me where I parked yesterday when checking in.
# * If I did not park yesterday, the system tells me that I did not park yesterday when checking in.
# * If I parked before today, the system prefills my spot number with the spot I last parked in.
# * If I have not parked, the system does not prefill the spot number.

# Also covers:
# As a parker
# I want the system to suggest the last spot I parked in
# So that I don't have to re-enter the slot number

  scenario 'system remembers parking spot' do
    spot_number = '12'
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: 'sjones@sam.com'
    fill_in 'Parking spot', with: spot_number
    click_button 'Submit'

    visit '/'
    spot_number_field = find_field('Parking spot number').value
    expect(spot_number_field).to eq(spot_number)
  end

  scenario 'user parked yesterday and is parking in the same spot today' do
    email = 'my@email.com'
    spot_number = '12'
    FactoryGirl.create(:registration, email: email, parking_spot_number: spot_number, parked_on: Date.today.prev_day)
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: email
    fill_in 'Parking spot', with: spot_number
    click_button 'Submit'
    expect(page).to have_content(spot_number)
    expect(page).to have_content('You are parked in the same spot as yesterday!')
  end

  scenario 'user parked yesterday and is parking in a different spot today' do
    email = 'my@email.com'
    spot_number = '12'
    FactoryGirl.create(:registration, email: email, parking_spot_number: spot_number, parked_on: Date.today.prev_day)
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: email
    fill_in 'Parking spot', with: '25'
    click_button 'Submit'
    expect(page).to have_content(spot_number)
    expect(page).to have_content('You are not parked in the same spot as yesterday!')
  end

end
