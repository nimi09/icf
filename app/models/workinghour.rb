# == Schema Information
#
# Table name: workinghours
#
#  id         :integer          not null, primary key
#  date       :datetime
#  hours      :integer
#  minutes    :integer
#  remarks    :string(255)
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Workinghour < ActiveRecord::Base
	belongs_to :project
	belongs_to :user

	attr_accessible :date, :hours, :minutes, :project_id, :remarks, :user_id

	validates :date, 	presence: true, format: { with: /\d{1,2}:\d{2}/ }
	validates :hours,	presence: true, :numericality => { greater_or_equal_to: 0, less_or_equal_to: 24 }
	validates :minutes,	presence: true, :numericality => { greater_or_equal_to: 0, less_or_equal_to: 59 }

	validates :remarks, length: {maximum: 200}

	validate :hours_and_minutes_greater_than_zero


	def hours_and_minutes_greater_than_zero
		if (hours == 0) && (minutes == 0)
			errors.add(:hours)
			errors.add(:minutes)
		end
	end

end
