require 'rails_helper'

RSpec.describe "jobs/index", type: :view do
  before(:each) do
    assign(:jobs, [
      Job.create!(
        :name => "Name",
        :description => "MyText",
        :ports => "MyText",
        :hosts => "MyText",
        :options => "MyText"
      ),
      Job.create!(
        :name => "Name",
        :description => "MyText",
        :ports => "MyText",
        :hosts => "MyText",
        :options => "MyText"
      )
    ])
  end

  it "renders a list of jobs" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
