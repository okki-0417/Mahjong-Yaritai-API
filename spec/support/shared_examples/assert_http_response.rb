# frozen_string_literal: true

RSpec.shared_examples :status do |status|
  it "have_http_response(n)" do
    subject
    expect(response).to have_http_status(status)
  end
end
