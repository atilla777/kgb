require 'rails_helper'

RSpec.describe "services/edit", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
      :name => "MyString",
      :organization => nil,
      :legality => 1,
      :host_ip => "MyString",
      :port => "MyString",
      :protocol => 1,
      :description => "MyText"
    ))
  end

  it "renders the edit service form" do
    render

    assert_select "form[action=?][method=?]", service_path(@service), "post" do

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
