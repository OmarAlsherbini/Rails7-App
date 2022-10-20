json.extract! user_event, :id, :event_id, :user_id, :user_physical_address, :user_lat_long, :user_performance, :created_at, :updated_at
json.url user_event_url(user_event, format: :json)
