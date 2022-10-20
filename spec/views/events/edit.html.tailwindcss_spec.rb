require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      month_app: nil,
      name: "MyString",
      all_day: false,
      event_type: 1,
      event_details: "MyString",
      event_value: 1
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[month_app_id]"

      assert_select "input[name=?]", "event[name]"

      assert_select "input[name=?]", "event[all_day]"

      assert_select "input[name=?]", "event[event_type]"

      assert_select "input[name=?]", "event[event_details]"

      assert_select "input[name=?]", "event[event_value]"
    end
  end
end
