require 'rails_helper'

RSpec.describe "option_sets/new", type: :view do
  before(:each) do
    assign(:option_set, OptionSet.new(
      :name => "MyString",
      :description => "MyString",
      :options => "MyText"
    ))
  end

  it "renders new option_set form" do
    render

    assert_select "form[action=?][method=?]", option_sets_path, "post" do

      assert_select "input#option_set_name[name=?]", "option_set[name]"

      assert_select "input#option_set_description[name=?]", "option_set[description]"

      assert_select "textarea#option_set_options[name=?]", "option_set[options]"
    end
  end
end
