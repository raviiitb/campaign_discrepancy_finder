require './lib/services/campaign_discrepancy_finder'
require './lib/models/campaign'
require 'pry'

RSpec.describe CampaignDiscrepancyFinder do
  before :all do
    DatabaseCleaner.clean
    Campaign.create(status: 'active', external_reference: '1', ad_description: 'Test')
  end

  context 'there is no discrepancy between remote and local campaign' do
    let(:remote_campaign) do
      [{ 'reference' => '1', 'status' => 'active', 'description' => 'Test' }]
    end
    it 'should return empty array' do
      result = CampaignDiscrepancyFinder.new(remote_campaign).run
      expect(JSON.parse(result)['data']).to eq([])
    end
  end

  context 'there are discrepancies between remote and local campaign' do
    context 'only status is different' do
      let(:remote_campaign) do
        [{ 'reference' => '1', 'status' => 'enabled', 'description' => 'Test' }]
      end
      let(:expect_output) do
        [
          {
            'discrepancies' => [
              {
                'status' => {
                  'local' => 'active',
                  'remote' => 'enabled'
                }
              }
            ],
            'remote_reference' => '1'
          }
        ]
      end
      it 'should include only status in the output' do
        result = CampaignDiscrepancyFinder.new(remote_campaign).run
        expect(JSON.parse(result)['data']).to eq(expect_output)
      end
    end

    context 'only description is different' do
      let(:remote_campaign) do
        [{ 'reference' => '1', 'status' => 'active', 'description' => 'different' }]
      end
      let(:expect_output) do
        [
          {
            'discrepancies' => [
              {
                'description' => {
                  'local' => 'Test',
                  'remote' => 'different'
                }
              }
            ],
            'remote_reference' => '1'
          }
        ]
      end
      it 'should include only description in the output' do
        result = CampaignDiscrepancyFinder.new(remote_campaign).run
        expect(JSON.parse(result)['data']).to eq(expect_output)
      end
    end

    context 'both status and description are different' do
      let(:remote_campaign) do
        [{ 'reference' => '1', 'status' => 'enabled', 'description' => 'different' }]
      end
      let(:expect_output) do
        [
          {
            'discrepancies' => [
              {
              'status' => {
                'local' => 'active',
                'remote' => 'enabled'
                }
              },
              {
                'description' => {
                  'local' => 'Test',
                  'remote' => 'different'
                }
              }
            ],
            'remote_reference' => '1'
          }
        ]
      end
      it 'should include both status and description in the output' do
        result = CampaignDiscrepancyFinder.new(remote_campaign).run
        expect(JSON.parse(result)['data']).to eq(expect_output)
      end
    end
  end
end
