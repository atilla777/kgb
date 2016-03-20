require 'rails_helper'

RSpec.describe "option_sets/edit", type: :view do
  before(:each) do
    @option_set = assign(:option_set, OptionSet.create!(
      :name => "MyString",
      :description => "MyString",
      :options => "MyText"
    ))
  end

  it "renders the edit option_set form" do
    render

    assert_select "form[action=?][method=?]", option_set_path(@option_set), "post" do

      assert_select "input#option_set_name[name=?]", "option_set[name]"

      assert_select "input#option_set_description[name=?]", "option_set[description]"

      assert_select "textarea#option_set_options[name=?]", "option_set[options]"
    end
  end
end
