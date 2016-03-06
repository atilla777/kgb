require 'rails_helper'

RSpec.describe "services/new", type: :view do
  before(:each) do
    assign(:service, Service.new(
      :name => "MyString",
      :organization => nil,
      :legality => 1,
      :host_ip => "MyString",
      :port => "MyString",
      :protocol => 1,
      :description => "MyText"
    ))
  end

  it "renders new service form" do
    render

    assert_select "form[action=?][method=?]", services_path, "post" do

      assert_select "input#service_name[name=?]", "service[name]"

      assert_select "input#service_organization_id[name=?]", "service[organization_id]"

      assert_select "input#service_legality[name=?]", "service[legality]"

      assert_select "input#service_host_ip[name=?]", "service[host_ip]"

      assert_select "input#service_port[name=?]", "service[port]"

      assert_select "input#service_protocol[name=?]", "service[protocol]"

      assert_select "textarea#service_description[name=?]", "service[description]"
    end
  end
end
