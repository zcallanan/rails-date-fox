class ActivityCategory < ApplicationRecord
  belongs_to :activity, optional: true
end
