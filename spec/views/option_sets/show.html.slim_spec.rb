require 'rails_helper'

RSpec.describe "option_sets/show", type: :view do
  before(:each) do
    @option_set = assign(:option_set, OptionSet.create!(
      :name => "Name",
      :description => "Description",
      :options => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/MyText/)
  end
end
