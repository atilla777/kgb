require 'rails_helper'

RSpec.describe "services/index", type: :view do
  before(:each) do
    assign(:services, [
      Service.create!(
        :name => "Name",
        :organization => nil,
        :legality => 1,
        :host_ip => "Host Ip",
        :port => "Port",
        :protocol => 2,
        :description => "MyText"
      ),
      Service.create!(
        :name => "Name",
        :organization => nil,
        :legality => 1,
        :host_ip => "Host Ip",
        :port => "Port",
        :protocol => 2,
        :description => "MyText"
      )
    ])
  end

  it "renders a list of services" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Host Ip".to_s, :count => 2
    assert_select "tr>td", :text => "Port".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
