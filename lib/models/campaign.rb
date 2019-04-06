class Campaign < ActiveRecord::Base
  enum status: %i[active deleted paused]
end