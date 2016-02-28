require 'rails_helper'

RSpec.describe "scanned_ports/show", type: :view do
  before(:each) do
    @scanned_port = assign(:scanned_port, ScannedPort.create!(
      :organization => nil,
      :host_ip => "Host Ip",
      :number => 1,
      :protocol => "Protocol",
      :state => "State",
      :service => "Service"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Host Ip/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Protocol/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/Service/)
  end
end
