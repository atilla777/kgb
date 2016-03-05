require 'rails_helper'

RSpec.describe "jobs/new", type: :view do
  before(:each) do
    assign(:job, Job.new(
      :name => "MyString",
      :description => "MyText",
      :ports => "MyText",
      :hosts => "MyText",
      :options => "MyText"
    ))
  end

  it "renders new job form" do
    render

    assert_select "form[action=?][method=?]", jobs_path, "post" do

      assert_select "input#job_name[name=?]", "job[name]"

      assert_select "textarea#job_description[name=?]", "job[description]"

      assert_select "textarea#job_ports[name=?]", "job[ports]"

      assert_select "textarea#job_hosts[name=?]", "job[hosts]"

      assert_select "textarea#job_options[name=?]", "job[options]"
    end
  end
end
