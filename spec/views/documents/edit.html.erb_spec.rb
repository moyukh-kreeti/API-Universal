require 'rails_helper'

RSpec.describe "documents/edit", type: :view do
  let(:document) {
    Document.create!(
      filename: "MyString"
    )
  }

  before(:each) do
    assign(:document, document)
  end

  it "renders the edit document form" do
    render

    assert_select "form[action=?][method=?]", document_path(document), "post" do

      assert_select "input[name=?]", "document[filename]"
    end
  end
end
