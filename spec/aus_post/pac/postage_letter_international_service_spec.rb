require 'spec_helper'

describe AusPost::PAC::PostageLetterInternationalService do
  let(:required_attributes) {
    {
      country_code: 'NZ',
      weight:       100
    }
  }
  let(:optional_attributes) { {} }

  it_behaves_like 'an api'
end
