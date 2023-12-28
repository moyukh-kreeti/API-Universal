require 'rails_helper'

RSpec.describe "documents/index", type: :view do
  before(:each) do
    assign(:documents, [
      Document.create!(
        filename: "Filename"
      ),
      Document.create!(
        filename: "Filename"
      )
    ])
  end

  it "renders a list of documents" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Filename".to_s), count: 2
  end
end
