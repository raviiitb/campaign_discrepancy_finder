require './lib/models/campaign'

RSpec.describe Campaign, type: :model do
  it 'should create campaign with given data' do
    Campaign.create(ad_description: 'Test')
    expect(Campaign.count).to eq(1)
    expect(Campaign.last.ad_description).to eq('Test')
  end
end
