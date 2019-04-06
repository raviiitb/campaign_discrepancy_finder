class CampaignDiscrepancyFinder
  def initialize(campaigns)
    @campaigns = campaigns
  end

  def run
    @campaigns.each_with_object([]) do |campaign, response|
      local_camp = Campaign.find_by(external_reference: campaign[:reference])
      if discrepancy?(local_camp, campaign)
      end
    end
  end

  private

  def discrepancy?(local, remote)
    false
  end
end