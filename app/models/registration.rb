class Registration < ActiveRecord::Base

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :parked_on

  validates_format_of :email,
    with: /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i

  validates_numericality_of :parking_spot_number, :only_integer => true,
    :greater_than_or_equal_to => 1,
    :less_than_or_equal_to => 60,
    :message => "only goes between 1-60"

  validates_uniqueness_of :parking_spot_number, scope: :parked_on

  def park
    self.parked_on = Date.today
    save
  end

end
