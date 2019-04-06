class CampaignDiscrepancyFinder
  def initialize(campaigns)
    @campaigns = campaigns
  end

  def run
    @campaigns.each_with_object([]) do |campaign, response|
      local_camp = Campaign.find_by(external_reference: campaign[:reference])
      if discrepancy?(local_camp, campaign)
        response << build_camp_response(local_camp, campaign)
      end
    end
  end

  private

  def build_camp_response(local, remote)
    {
      remote_reference: remote[:reference],
      discrepancies: discrepancies(local, remote)
    }
  end

  def discrepancy?(local, remote)
    local.status != remote[:status] ||
      local.ad_description != remote[:description]
  end

  def discrepancies(local, remote)
    output = []
    if local.status != remote[:status]
      output << { status: { remote: remote[:status],
                            local: local.status } }
    end
    output
  end
end
