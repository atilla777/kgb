require 'rails_helper'

RSpec.describe "users/edit", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :name => "MyString",
      :phone => "MyString",
      :job => "MyString",
      :description => "MyText",
      :organization => nil,
      :department => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    assert_select "form[action=?][method=?]", user_path(@user), "post" do

      assert_select "input#user_name[name=?]", "user[name]"

      assert_select "input#user_phone[name=?]", "user[phone]"

      assert_select "input#user_job[name=?]", "user[job]"

      assert_select "textarea#user_description[name=?]", "user[description]"

      assert_select "input#user_organization_id[name=?]", "user[organization_id]"

      assert_select "input#user_department[name=?]", "user[department]"
    end
  end
end
