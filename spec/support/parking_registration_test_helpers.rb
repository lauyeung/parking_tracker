module ParkingRegistrationTestHelpers
  def create_registration_for(parking_spot_number)
    visit '/'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Parking spot number', with: parking_spot_number
    click_button 'Submit'
  end
end
