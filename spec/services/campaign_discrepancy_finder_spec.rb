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

  context 'there are discrepancies between remote and local campaign' do
    context 'only status is different' do
      let(:remote_campaign) do
        [{ reference: '1', status: 'enabled', description: 'Test' }]
      end
      let(:expect_output) do
        [
          {
            discrepancies: [
              {
                status: {
                  local: 'active',
                  remote: 'enabled'
                }
              }
            ],
            remote_reference: '1'
          }
        ]
      end
      it 'should include only status in the output' do
        expect(CampaignDiscrepancyFinder.new(remote_campaign).run).to eq(expect_output)
      end
    end
  end
end
