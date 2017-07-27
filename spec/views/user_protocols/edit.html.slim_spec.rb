require 'rails_helper'

RSpec.describe "user_protocols/edit", type: :view do
  before(:each) do
    @user_protocol = assign(:user_protocol, UserProtocol.create!(
      :user => nil,
      :ip_adress => "MyString",
      :action => "MyString",
      :controller => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit user_protocol form" do
    render

    assert_select "form[action=?][method=?]", user_protocol_path(@user_protocol), "post" do

      assert_select "input#user_protocol_user_id[name=?]", "user_protocol[user_id]"

      assert_select "input#user_protocol_ip_adress[name=?]", "user_protocol[ip_adress]"

      assert_select "input#user_protocol_action[name=?]", "user_protocol[action]"

      assert_select "input#user_protocol_controller[name=?]", "user_protocol[controller]"

      assert_select "input#user_protocol_description[name=?]", "user_protocol[description]"
    end
  end
end
