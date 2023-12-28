require 'rails_helper'

RSpec.describe "documents/show", type: :view do
  before(:each) do
    assign(:document, Document.create!(
      filename: "Filename"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Filename/)
  end
end
