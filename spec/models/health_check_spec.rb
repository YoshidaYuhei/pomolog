# == Schema Information
#
# Table name: health_checks
#
#  id         :bigint           not null, primary key
#  message    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe HealthCheck, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
