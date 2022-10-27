class Event < ApplicationRecord
  belongs_to :month_app
  has_many :user_event
  has_many :users, through: :user_event
  attr_accessor :user_id
  # after_create :create_user_event

  private

  # def create_user_event
  #   UserEvent.create(event_id: self.id, user_id: current_user.id, user_physical_address: @user_physical_address, user_lat_long: @user_lat_long)
  # end

  def self.call_from_controller(user_id)
    user_events_all = UserEvent.where(user_id: user_id).order(:id)
    eventData= Array.new
    for user_event in user_events_all
      eventData.append({
        "startDate" => user_event.event.start_date,
        "endDate" => user_event.event.end_date,
        "eventType" => user_event.event.event_type,
        "eventDetails" => user_event.event.event_details,
        "userFirstName" => user_event.user_first_name,
        "userLastName" => user_event.user_last_name,
        "userPhoneNumber" => user_event.user_phone_number,
        "userPhysicalAddress" => user_event.user_physical_address,
        "userLatLong" => user_event.user_lat_long,
        "userPerformance" => user_event.user_performance,
        "eventValue" => user_event.event.event_value,
      })
    end
    return eventData
  end

  def self.check_events_conflict(old_start_date, old_end_date, new_start_date, new_end_date, old_overwritable, new_overwritable)
    if !old_overwritable and !new_overwritable and ((old_start_date > new_start_date and old_start_date < new_end_date) or (old_end_date > new_start_date and old_end_date < new_end_date) or (old_start_date < new_start_date and old_end_date > new_end_date) or (old_start_date > new_start_date and old_end_date < new_end_date))
      return true
    else
      return false
    end
  end

end