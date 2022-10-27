require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, Event.new(
      month_app: nil,
      name: "MyString",
      all_day: false,
      event_type: 1,
      event_details: "MyString",
      event_value: 1
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input[name=?]", "event[month_app_id]"

      assert_select "input[name=?]", "event[name]"

      assert_select "input[name=?]", "event[all_day]"

      assert_select "input[name=?]", "event[event_type]"

      assert_select "input[name=?]", "event[event_details]"

      assert_select "input[name=?]", "event[event_value]"
    end
  end
end
