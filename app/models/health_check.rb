# == Schema Information
#
# Table name: health_checks
#
#  id         :bigint           not null, primary key
#  message    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class HealthCheck < ApplicationRecord
end
