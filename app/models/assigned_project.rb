# == Schema Information
#
# Table name: assigned_projects
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  position   :string(255)
#

class AssignedProject < ActiveRecord::Base
	belongs_to :user#,    class_name: "User"
	belongs_to :project#, class_name: "Project"

	attr_accessible :project_id, :user_id, :position, :project, :project_attributes

	accepts_nested_attributes_for :project

#	validates :user_id,    	presence: true
#	validates :project_id, 	presence: true

	validates :position,  presence: { message: " can't be blank." }

#	validate do |ap|
#		errors.add('XXX') if ap.position.blank?
#	end

end
