require 'rails_helper'

RSpec.describe "user_events/index", type: :view do
  before(:each) do
    assign(:user_events, [
      UserEvent.create!(
        Event: nil,
        user: nil,
        user_physical_address: "User Physical Address",
        user_lat_long: "User Lat Long",
        user_performance: 2.5
      ),
      UserEvent.create!(
        Event: nil,
        user: nil,
        user_physical_address: "User Physical Address",
        user_lat_long: "User Lat Long",
        user_performance: 2.5
      )
    ])
  end

  it "renders a list of user_events" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "User Physical Address".to_s, count: 2
    assert_select "tr>td", text: "User Lat Long".to_s, count: 2
    assert_select "tr>td", text: 2.5.to_s, count: 2
  end
end
