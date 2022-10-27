require 'rails_helper'

RSpec.describe "user_events/edit", type: :view do
  before(:each) do
    @user_event = assign(:user_event, UserEvent.create!(
      Event: nil,
      user: nil,
      user_physical_address: "MyString",
      user_lat_long: "MyString",
      user_performance: 1.5
    ))
  end

  it "renders the edit user_event form" do
    render

    assert_select "form[action=?][method=?]", user_event_path(@user_event), "post" do

      assert_select "input[name=?]", "user_event[Event_id]"

      assert_select "input[name=?]", "user_event[user_id]"

      assert_select "input[name=?]", "user_event[user_physical_address]"

      assert_select "input[name=?]", "user_event[user_lat_long]"

      assert_select "input[name=?]", "user_event[user_performance]"
    end
  end
end
