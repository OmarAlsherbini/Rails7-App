require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        month_app: nil,
        name: "Name",
        all_day: false,
        event_type: 2,
        event_details: "Event Details",
        event_value: 3
      ),
      Event.create!(
        month_app: nil,
        name: "Name",
        all_day: false,
        event_type: 2,
        event_details: "Event Details",
        event_value: 3
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", text: nil.to_s, count: 2
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Event Details".to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
  end
end
