require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "Name",
        :phone => "Phone",
        :job => "Job",
        :description => "MyText",
        :organization => nil,
        :department => "Department"
      ),
      User.create!(
        :name => "Name",
        :phone => "Phone",
        :job => "Job",
        :description => "MyText",
        :organization => nil,
        :department => "Department"
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Job".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Department".to_s, :count => 2
  end
end
