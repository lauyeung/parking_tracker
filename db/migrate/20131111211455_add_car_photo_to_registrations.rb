class AddCarPhotoToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :car_photo, :string
  end
end
