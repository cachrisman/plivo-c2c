class Call < ActiveRecord::Base
  serialize :request_uuids, Array
end
