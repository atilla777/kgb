require 'rails_helper'

RSpec.describe "scanned_ports/index", type: :view do
  before(:each) do
    assign(:scanned_ports, [
      ScannedPort.create!(
        :organization => nil,
        :host_ip => "Host Ip",
        :number => 1,
        :protocol => "Protocol",
        :state => "State",
        :service => "Service"
      ),
      ScannedPort.create!(
        :organization => nil,
        :host_ip => "Host Ip",
        :number => 1,
        :protocol => "Protocol",
        :state => "State",
        :service => "Service"
      )
    ])
  end

  it "renders a list of scanned_ports" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Host Ip".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Protocol".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Service".to_s, :count => 2
  end
end
