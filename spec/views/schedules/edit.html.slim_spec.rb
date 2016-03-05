require 'rails_helper'

RSpec.describe "schedules/edit", type: :view do
  before(:each) do
    @schedule = assign(:schedule, Schedule.create!(
      :job => nil,
      :week_day => 1,
      :month_day => 1
    ))
  end

  it "renders the edit schedule form" do
    render

    assert_select "form[action=?][method=?]", schedule_path(@schedule), "post" do

      assert_select "input#schedule_job_id[name=?]", "schedule[job_id]"

      assert_select "input#schedule_week_day[name=?]", "schedule[week_day]"

      assert_select "input#schedule_month_day[name=?]", "schedule[month_day]"
    end
  end
end
