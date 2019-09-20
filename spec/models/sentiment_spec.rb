# == Schema Information
#
# Table name: sentiments
#
#  id             :bigint(8)        not null, primary key
#  value          :text
#  mixed_score    :float
#  negative_score :float
#  neutral_score  :float
#  positive_score :float
#  comment_id     :bigint(8)
#  user_id        :bigint(8)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Sentiment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
