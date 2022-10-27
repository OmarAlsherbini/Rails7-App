json.extract! event, :id, :month_app_id, :name, :all_day, :start_date, :end_date, :event_type, :event_details, :event_value, :created_at, :updated_at
json.url event_url(event, format: :json)
