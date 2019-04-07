## Gems used
* `database_cleaner:` Clean up the database after each test
* `rspec:` Testing
* `sqlite3:` Database
* `standalone_migrations:` Rails activerecord

## Code design
There is a service called `CampaignDiscrepancyFinder` which accepts campaigns from the remote and returns json containing the information of non-synched campaigns.
This service can be used as following
```CampaignDiscrepancyFinder.new(campaigns).run```
where `campaigns` is the array of the campaigns from remote in the following structure.
```json
[
  {
    "reference": "1",
    "status": "enabled",
    "description": "Description for campaign 11"
  },
  {
    "reference": "2",
    "status": "disabled",
    "description": "Description for campaign 12"
  },...
]
```
Service will check into the `Campaigns` table to find if there is any discrepancy in the local campaigns and remote campaigns. If it finds such campaigns, it returns response in the following way.
```json
data: [
  {
    "remote_reference": "1",
    "discrepancies": [
      "status": {
        "remote": "disabled",
        "local": "active"
      },
      "description": {
      "remote": "Rails Engineer",
      "local": "Ruby on Rails Developer"
      },...
    ]
  }
]
```
There is a model called `Campaign` having following attributes.
* `integer "job_id"`
* `integer "status"`
* `string "external_reference"`
* `text "ad_description"`
