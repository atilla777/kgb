require 'rails_helper'

RSpec.describe "schedules/show", type: :view do
  before(:each) do
    @schedule = assign(:schedule, Schedule.create!(
      :job => nil,
      :week_day => 1,
      :month_day => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
