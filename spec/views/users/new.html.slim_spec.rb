require 'rails_helper'

RSpec.describe "users/new", type: :view do
  before(:each) do
    assign(:user, User.new(
      :name => "MyString",
      :phone => "MyString",
      :job => "MyString",
      :description => "MyText",
      :organization => nil,
      :department => "MyString"
    ))
  end

  it "renders new user form" do
    render

    assert_select "form[action=?][method=?]", users_path, "post" do

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "input#user_phone[name=?]", "user[phone]"

      assert_select "input#user_job[name=?]", "user[job]"

      assert_select "textarea#user_description[name=?]", "user[description]"

      assert_select "input#user_organization_id[name=?]", "user[organization_id]"

      assert_select "input#user_department[name=?]", "user[department]"
    end
  end
end
