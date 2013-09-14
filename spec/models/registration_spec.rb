require 'spec_helper'

describe Registration do
  it { should_not have_valid(:first_name).when(nil, '') }
  it { should_not have_valid(:last_name).when(nil, '') }
  it { should_not have_valid(:email).when(nil, '') }

  it { should have_valid(:parking_spot_number).when(12, '50') }
  it { should_not have_valid(:parking_spot_number).when(nil, '', 100) }

end
