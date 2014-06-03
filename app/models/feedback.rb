# == Schema Information
#
# Table name: feedbacks
#
#  id         :integer          not null, primary key
#  subject    :string(255)
#  content    :string(255)
#  votes      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Feedback < ActiveRecord::Base
  attr_accessible :content, :subject, :votes

  validates :subject, presence: true, length: { minimum: 3, maximum: 100 }
  validates :content, presence: true, length: { minimum: 3, maximum: 500 }
end
