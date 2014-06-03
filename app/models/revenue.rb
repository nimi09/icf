# == Schema Information
#
# Table name: revenues
#
#  id          :integer          not null, primary key
#  description :string(255)
#  amount      :decimal(8, 2)
#  date        :datetime
#  project_id  :integer
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Revenue < ActiveRecord::Base
	belongs_to :project
	belongs_to :user

	attr_accessible :amount, :date, :description, :project_id, :user_id

	validates :description, presence: true, length: { minimum: 3, maximum: 200 }
	validates :amount,		presence: true, format: { with: /^\d+??(?:\.\d{0,2})?$/ }, numericality: { greater_than: 0 }
	validates :date,		presence: true, format: { with: /\d{1,2}:\d{2}/ }

end
