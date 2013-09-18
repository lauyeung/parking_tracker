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

  def create_notice
    messages = ["Thanks for registering your car!"]
    if has_neighbors
      if @below_neighbor.present?
        messages << "Spot #{@below_neighbor.parking_spot_number} is occupied by #{@below_neighbor.first_name} #{@below_neighbor.last_name}."
      end
      if @above_neighbor.present?
        messages << "Spot #{@above_neighbor.parking_spot_number} is occupied by #{@above_neighbor.first_name} #{@above_neighbor.last_name}."
      end
    else
      messages << "You have no neighbors."
    end
    messages
  end

  private

  def has_neighbors
    has_below_neighbor
    has_above_neighbor
    has_below_neighbor || has_above_neighbor
    end

  def has_below_neighbor
    if self.parking_spot_number.present?
      below_neighbor_spot_number = self.parking_spot_number - 1
      if self.class.where({parking_spot_number: below_neighbor_spot_number}).count > 0
        below_neighbor_array = self.class.where({parking_spot_number: below_neighbor_spot_number})
        @below_neighbor = below_neighbor_array[0]
        true
      else
        false
      end
    end
  end

  def has_above_neighbor
    if self.parking_spot_number.present?
      above_neighbor_spot_number = self.parking_spot_number + 1
      if self.class.where({parking_spot_number: above_neighbor_spot_number}).count > 0
        above_neighbor_array = self.class.where({parking_spot_number: above_neighbor_spot_number})
        @above_neighbor = above_neighbor_array[0]
        true
      else
        false
      end
    end

  end

end
