require 'rails_helper'

RSpec.describe "jobs/show", type: :view do
  before(:each) do
    @job = assign(:job, Job.create!(
      :name => "Name",
      :description => "MyText",
      :ports => "MyText",
      :hosts => "MyText",
      :options => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
  end
end
