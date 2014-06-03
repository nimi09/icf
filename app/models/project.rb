# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  controlled :boolean
#  currency   :string(255)
#  creator_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Project < ActiveRecord::Base
  belongs_to :user
  has_many :assigned_projects
  has_many :users, :through => :assigned_projects
  belongs_to :creator, :class_name => "User", :foreign_key => :creator_id

  has_many :expenses
  has_many :rentals
  has_many :workinghours
  has_many :revenues

#  default_scope -> { order('created_at DESC') }  #  rails 4!
  default_scope order: "projects.created_at DESC"

  attr_accessible :name, :controlled, :currency, :creator_id, :assigned_projects_attributes
  
  accepts_nested_attributes_for :assigned_projects#, :allow_destroy => true

  validates :name, presence: true, length: { minimum: 3, maximum: 100 }
  validates :currency, presence: true, length: { minimum: 1, maximum: 5 }
  validates :creator_id, presence: true

end
