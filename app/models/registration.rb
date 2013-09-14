class Registration < ActiveRecord::Base

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :parking_spot_number

  validates_uniqueness_of :parking_spot_number,
    :message => "has already been taken"

  validates_numericality_of :parking_spot_number, :only_integer => true,
    :greater_than_or_equal_to => 1,
    :less_than_or_equal_to => 60,
    :message => "only goes between 1-60"

end
