require 'rails_helper'

RSpec.describe "option_sets/index", type: :view do
  before(:each) do
    assign(:option_sets, [
      OptionSet.create!(
        :name => "Name",
        :description => "Description",
        :options => "MyText"
      ),
      OptionSet.create!(
        :name => "Name",
        :description => "Description",
        :options => "MyText"
      )
    ])
  end

  it "renders a list of option_sets" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
