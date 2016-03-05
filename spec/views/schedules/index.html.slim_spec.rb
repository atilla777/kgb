require 'rails_helper'

RSpec.describe "schedules/index", type: :view do
  before(:each) do
    assign(:schedules, [
      Schedule.create!(
        :job => nil,
        :week_day => 1,
        :month_day => 2
      ),
      Schedule.create!(
        :job => nil,
        :week_day => 1,
        :month_day => 2
      )
    ])
  end

  it "renders a list of schedules" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
