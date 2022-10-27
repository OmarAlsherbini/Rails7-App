require 'rails_helper'

RSpec.describe "user_events/show", type: :view do
  before(:each) do
    @user_event = assign(:user_event, UserEvent.create!(
      Event: nil,
      user: nil,
      user_physical_address: "User Physical Address",
      user_lat_long: "User Lat Long",
      user_performance: 2.5
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/User Physical Address/)
    expect(rendered).to match(/User Lat Long/)
    expect(rendered).to match(/2.5/)
  end
end
