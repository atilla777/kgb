require 'rails_helper'

RSpec.describe "schedules/new", type: :view do
  before(:each) do
    assign(:schedule, Schedule.new(
      :job => nil,
      :week_day => 1,
      :month_day => 1
    ))
  end

  it "renders new schedule form" do
    render

    assert_select "form[action=?][method=?]", schedules_path, "post" do

      assert_select "input#schedule_job_id[name=?]", "schedule[job_id]"

      assert_select "input#schedule_week_day[name=?]", "schedule[week_day]"

      assert_select "input#schedule_month_day[name=?]", "schedule[month_day]"
    end
  end
end
