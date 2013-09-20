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

  def messages
    message_array = []
    if self.has_neighbors?
      self.neighbors.each do |neighbor|
        if neighbor.present?
          message_array << "Spot #{neighbor.parking_spot_number} is occupied by #{neighbor.first_name} #{neighbor.last_name}."
        end
      end
    else
      message_array << "You have no neighbors. =("
    end

    if yesterday_spot
      message_array << "You parked in spot #{@yesterday.parking_spot_number} yesterday."
      if same_spot_as_yesterday?
        message_array << "You are parked in the same spot as yesterday!"
      else
        message_array << "You are not parked in the same spot as yesterday!"
      end
    end


    message_array
  end

  def has_neighbors?
    neighbors != [nil, nil]
  end

  def neighbors
    neighbors = Registration.where(
      "(parking_spot_number = :below OR parking_spot_number = :above)
      AND parked_on = :parked_on", {
        below: self.parking_spot_number - 1,
        above: self.parking_spot_number + 1,
        parked_on: self.parked_on
    }).order("parking_spot_number")

    if neighbors.size == 2
      neighbors
    elsif neighbors.size == 0
      [nil, nil]
    else
      if neighbors[0].parking_spot_number > self.parking_spot_number
        [nil, neighbors[0]]
      else
        [neighbors[0], nil]
      end
    end
  end

  def yesterday_spot
    yesterday = Registration.where({:email => self.email, :parked_on => self.parked_on.prev_day}).order("created_at DESC").limit(1)
    if yesterday.present?
      @yesterday = yesterday[0]
    end
  end

  def same_spot_as_yesterday?
    yesterday_spot
    if self.parking_spot_number == @yesterday.parking_spot_number
      true
    else
      false
    end
  end

end
