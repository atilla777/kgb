require 'rails_helper'

RSpec.describe "services/show", type: :view do
  before(:each) do
    @service = assign(:service, Service.create!(
      :name => "Name",
      :organization => nil,
      :legality => 1,
      :host_ip => "Host Ip",
      :port => "Port",
      :protocol => 2,
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Host Ip/)
    expect(rendered).to match(/Port/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
  end
end
