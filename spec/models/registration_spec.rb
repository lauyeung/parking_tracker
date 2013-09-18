require 'spec_helper'

describe Registration do
  it { should_not have_valid(:first_name).when(nil, '') }
  it { should_not have_valid(:last_name).when(nil, '') }
  it { should_not have_valid(:email).when(nil, '') }

  it { should have_valid(:parking_spot_number).when(12, '50') }
  it { should_not have_valid(:parking_spot_number).when(nil, '', 100) }

  it 'only allows one registration in one spot per day' do
    prev_registration = FactoryGirl.create(:registration)
    registration = FactoryGirl.build(:registration,
      parking_spot_number: prev_registration.parking_spot_number,
      parked_on: prev_registration.parked_on)
    expect(registration.park).to be_false
    expect(registration).to_not be_valid
    expect(registration.errors[:parking_spot_number]).to_not be_blank
  end

  # it 'has a below neighbor' do
  #   below_registration = FactoryGirl.create(:registration, parking_spot_number: 5)
  #   registration = FactoryGirl.build(:registration, parking_spot_number: 6)
  #   expect(registration.has_below_neighbor).to be_true
  #   expect(registration.has_neighbors).to be_true
  # end

  # it 'has an above neighbor' do
  #   below_registration = FactoryGirl.create(:registration, parking_spot_number: 18)
  #   registration = FactoryGirl.build(:registration, parking_spot_number: 17)
  #   expect(registration.create).to be_true
  #   expect(registration.has_neighbors).to be_true
  # end

  # it 'has no neighbors' do
  #   registration = FactoryGirl.build(:registration, parking_spot_number: 35)
  #   expect(registration.has_neighbors).to be_false
  # end

  # it 'is the first spot' do
  #   registration = FactoryGirl.build(:registration, parking_spot_number: 1)
  #   expect(registration.has_neighbors).to be_false
  # end

end
