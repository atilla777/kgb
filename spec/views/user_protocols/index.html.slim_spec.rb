require 'rails_helper'

RSpec.describe "user_protocols/index", type: :view do
  before(:each) do
    assign(:user_protocols, [
      UserProtocol.create!(
        :user => nil,
        :ip_adress => "Ip Adress",
        :action => "Action",
        :controller => "Controller",
        :description => "Description"
      ),
      UserProtocol.create!(
        :user => nil,
        :ip_adress => "Ip Adress",
        :action => "Action",
        :controller => "Controller",
        :description => "Description"
      )
    ])
  end

  it "renders a list of user_protocols" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Ip Adress".to_s, :count => 2
    assert_select "tr>td", :text => "Action".to_s, :count => 2
    assert_select "tr>td", :text => "Controller".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
