class CampaignDiscrepancyFinder
# campaigns: Array
# [
#   {
#     "reference": "1",
#     "status": "enabled",
#     "description": "Description for campaign 11"
#   },
#   {
#     "reference": "2",
#     "status": "disabled",
#     "description": "Description for campaign 12"
#   }
#  ]
  def initialize(campaigns)
    @campaigns = campaigns
  end

# Returns empty array([]) when there is no discrepancy
# data: [
#   {
#     "remote_reference": "1",
#     "discrepancies": [
#       "status": {
#         "remote": "disabled",
#         "local": "active"
#       },
#       "description": {
#         "remote": "Rails Engineer",
#         "local": "Ruby on Rails Developer"
#       }
#     ]
#   }
# ]
  def run
    data = @campaigns.each_with_object([]) do |campaign, response|
              local_camp = Campaign.find_by(external_reference: campaign['reference'])
              if discrepancy?(local_camp, campaign)
                response << build_camp_response(local_camp, campaign)
              end
            end
    { data: data }.to_json
  end

  private

  # Single campaign response structure
  def build_camp_response(local, remote)
    {
      remote_reference: remote['reference'],
      discrepancies: discrepancies(local, remote)
    }
  end

  # true if either of status or description or both are different
  def discrepancy?(local, remote)
    local.status != remote['status'] ||
      local.ad_description != remote['description']
  end

  def discrepancies(local, remote)
    output = []
    if local.status != remote['status']
      output << { status: { remote: remote['status'],
                            local: local.status } }
    end
    if local.ad_description != remote['description']
      output << { description: { remote: remote['description'],
                                 local: local.ad_description } }
    end
    output
  end
end
