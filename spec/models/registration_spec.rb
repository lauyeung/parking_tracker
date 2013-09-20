require 'spec_helper'

describe Registration do
  it { should_not have_valid(:first_name).when(nil, '') }
  it { should_not have_valid(:last_name).when(nil, '') }
  it { should_not have_valid(:email).when(nil, '') }

  it { should have_valid(:parking_spot_number).when(12, '50') }
  it { should_not have_valid(:parking_spot_number).when(nil, '', 100) }

  describe 'parking' do
    it 'parks the car for today' do
      registration = FactoryGirl.build(:registration, parked_on: nil)
      expect(registration.park).to eql(true)
      expect(registration.parked_on).to eql(Date.today)
    end

    it 'only allows one registration in one spot per day' do
      prev_registration = FactoryGirl.create(:registration)
      registration = FactoryGirl.build(:registration,
        parking_spot_number: prev_registration.parking_spot_number,
        parked_on: prev_registration.parked_on)
      expect(registration.park).to be_false
      expect(registration).to_not be_valid
      expect(registration.errors[:parking_spot_number]).to_not be_blank
    end
  end

describe 'neighbors' do
    it 'has a neighbor if there is a registration beneath me' do
      FactoryGirl.create(:registration,
        parking_spot_number: 20)

      low_neighbor = FactoryGirl.create(:registration,
        parking_spot_number: 5)
      reg = FactoryGirl.build(:registration,
        parking_spot_number: 6)
      expect(reg.neighbors).to eql([low_neighbor, nil])
      expect(reg.has_neighbors?).to be_true
    end

    it 'has a neighbor if there is a registration above me' do
      FactoryGirl.create(:registration,
        parking_spot_number: 20)

      high_neighbor = FactoryGirl.create(:registration,
        parking_spot_number: 7)
      reg = FactoryGirl.build(:registration,
        parking_spot_number: 6)
      expect(reg.neighbors).to eql([nil, high_neighbor])
      expect(reg.has_neighbors?).to be_true
    end

    it 'has no neighbors if there is no registrations near me' do
      FactoryGirl.create(:registration,
        parking_spot_number: 20)
      reg = FactoryGirl.build(:registration,
        parking_spot_number: 6)
      expect(reg.neighbors).to eql([nil, nil])
      expect(reg.has_neighbors?).to_not be_true
    end

    it 'sorts neighbors properly' do
      high_neighbor = FactoryGirl.create(:registration,
        parking_spot_number: 7)
      low_neighbor = FactoryGirl.create(:registration,
        parking_spot_number: 5)
      reg = FactoryGirl.build(:registration,
        parking_spot_number: 6)

      expect(reg.neighbors).to eq([low_neighbor, high_neighbor])
    end

  end

  describe 'yesterday spot number' do
    it 'returns true when spot from yesterday found' do
      email = 'my@email.com'
      yesterday_spot_number = 55
      FactoryGirl.create(:registration, email: email, parking_spot_number: yesterday_spot_number, parked_on: Date.today.prev_day)
      reg = FactoryGirl.build(:registration, email: email)
      expect(reg.yesterday_spot).to be_true
    end


    it 'returns false when no spot number from yesterday found' do
      FactoryGirl.create(:registration, parked_on: Date.today.prev_day)
      reg = FactoryGirl.build(:registration)
      expect(reg.yesterday_spot).to be_false
    end

    it 'returns true when parked in the same spot' do
      email = 'my@email.com'
      yesterday_spot_number = 55
      FactoryGirl.create(:registration, email: email, parking_spot_number: yesterday_spot_number, parked_on: Date.today.prev_day)
      reg = FactoryGirl.build(:registration, email: email, parking_spot_number: yesterday_spot_number)
      expect(reg.same_spot_as_yesterday?).to be_true
    end

    it 'returns true when parked in the same spot' do
      email = 'my@email.com'
      yesterday_spot_number = 55
      FactoryGirl.create(:registration, email: email, parking_spot_number: yesterday_spot_number, parked_on: Date.today.prev_day)
      reg = FactoryGirl.build(:registration, email: email)
      expect(reg.same_spot_as_yesterday?).to be_false
    end

    it 'only returns one yesterday result' do
      email = 'my@email.com'
      FactoryGirl.create(:registration, email: email, parking_spot_number: '12', parked_on: Date.today.prev_day)
      FactoryGirl.create(:registration, email: email, parking_spot_number: '28', parked_on: Date.today.prev_day)
      reg = FactoryGirl.build(:registration, email: email)
      expect(reg.yesterday_spot.parking_spot_number).to eql(28)
    end

  end


end
