require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      month_app: nil,
      name: "Name",
      all_day: false,
      event_type: 2,
      event_details: "Event Details",
      event_value: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Event Details/)
    expect(rendered).to match(/3/)
  end
end
