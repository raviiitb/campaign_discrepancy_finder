require './lib/services/campaign_discrepancy_finder'
require './lib/models/campaign'

RSpec.describe CampaignDiscrepancyFinder do
  before :all do
    DatabaseCleaner.clean
    Campaign.create(status: 'active', external_reference: '1', ad_description: 'Test')
  end

  context 'there is no discrepancy between remote and local campaign' do
    let(:remote_campaign) do
      [{ reference: '1', status: 'active', description: 'Test' }]
    end
    it 'should return empty array' do
      expect(CampaignDiscrepancyFinder.new(remote_campaign).run).to eq([])
    end
  end
end
