# == Schema Information
#
# Table name: rentals
#
#  id             :integer          not null, primary key
#  description    :string(255)
#  amount         :decimal(8, 2)
#  amount_per_day :decimal(8, 2)
#  first_date     :datetime
#  last_date      :datetime
#  project_id     :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Rental < ActiveRecord::Base
	belongs_to :project
	belongs_to :user	

	attr_accessible :amount_per_day, :description, :first_date, :last_date

	validates :description, 	presence: true, length: { minimum: 3, maximum: 200 }
	validates :amount_per_day,	presence: true, format: { with: /^\d+??(?:\.\d{0,2})?$/ }, :numericality => { :greater_than => 0  }
	validates :first_date,		presence: true, format: { with: /\d{1,2}:\d{2}/ }
	validates :last_date,		presence: true, format: { with: /\d{1,2}:\d{2}/ }

	validates :amount,			 presence: { message: "could not be calculated" }

end
