require 'rails_helper'

RSpec.describe "user_protocols/show", type: :view do
  before(:each) do
    @user_protocol = assign(:user_protocol, UserProtocol.create!(
      :user => nil,
      :ip_adress => "Ip Adress",
      :action => "Action",
      :controller => "Controller",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Ip Adress/)
    expect(rendered).to match(/Action/)
    expect(rendered).to match(/Controller/)
    expect(rendered).to match(/Description/)
  end
end
