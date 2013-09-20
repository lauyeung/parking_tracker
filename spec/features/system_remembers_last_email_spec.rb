require 'spec_helper'

feature "system remembers email", %Q{
  As a parker
  I want the system to remember my email
  So that I don't have to re-enter it
} do

# Acceptance Criteria:
# * If I have previously checked in via the same web browser, my email is remembered so that I don't have to re-enter it
# * If I have not previously checked in, the email address field is left blank

# Refer to user_registers_parking_spot_spec for case that email is not remembered

  scenario 'system remembers email' do
    email = 'sjones@sam.com'
    visit '/'
    fill_in 'First name', with: 'Sophia'
    fill_in 'Last name', with: 'Jones'
    fill_in 'Email', with: email
    fill_in 'Parking spot', with: '1'
    click_button 'Submit'

    visit '/'
    email_field = find_field('Email').value
    expect(email_field).to eq(email)
    # Below line works the same way as 2 lines above - looks at the selector
    # expect(page).to have_selector("input[value='#{email}']")

  end

end
