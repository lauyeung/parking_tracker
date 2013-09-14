json.array!(@registrations) do |registration|
  json.extract! registration, :first_name, :last_name, :email, :parking_spot_number
  json.url registration_url(registration, format: :json)
end
