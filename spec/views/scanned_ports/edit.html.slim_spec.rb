require 'rails_helper'

RSpec.describe "scanned_ports/edit", type: :view do
  before(:each) do
    @scanned_port = assign(:scanned_port, ScannedPort.create!(
      :organization => nil,
      :host_ip => "MyString",
      :number => 1,
      :protocol => "MyString",
      :state => "MyString",
      :service => "MyString"
    ))
  end

  it "renders the edit scanned_port form" do
    render

    assert_select "form[action=?][method=?]", scanned_port_path(@scanned_port), "post" do

      assert_select "input#scanned_port_organization_id[name=?]", "scanned_port[organization_id]"

      assert_select "input#scanned_port_host_ip[name=?]", "scanned_port[host_ip]"

      assert_select "input#scanned_port_number[name=?]", "scanned_port[number]"

      assert_select "input#scanned_port_protocol[name=?]", "scanned_port[protocol]"

      assert_select "input#scanned_port_state[name=?]", "scanned_port[state]"

      assert_select "input#scanned_port_service[name=?]", "scanned_port[service]"
    end
  end
end
