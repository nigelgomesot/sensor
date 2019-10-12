# == Schema Information
#
# Table name: entities
#
#  id         :bigint(8)        not null, primary key
#  message_id :bigint(8)
#  user_id    :bigint(8)
#  category   :string
#  score      :decimal(, )
#  text       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class EntityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
