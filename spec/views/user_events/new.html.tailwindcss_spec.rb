require 'rails_helper'

RSpec.describe "user_events/new", type: :view do
  before(:each) do
    assign(:user_event, UserEvent.new(
      Event: nil,
      user: nil,
      user_physical_address: "MyString",
      user_lat_long: "MyString",
      user_performance: 1.5
    ))
  end

  it "renders new user_event form" do
    render

    assert_select "form[action=?][method=?]", user_events_path, "post" do

      assert_select "input[name=?]", "user_event[Event_id]"

      assert_select "input[name=?]", "user_event[user_id]"

      assert_select "input[name=?]", "user_event[user_physical_address]"

      assert_select "input[name=?]", "user_event[user_lat_long]"

      assert_select "input[name=?]", "user_event[user_performance]"
    end
  end
end
