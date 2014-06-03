# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  admin           :boolean          default(FALSE)
#

class User < ActiveRecord::Base
  has_many :assigned_projects
  has_many :projects, :through => :assigned_projects

  has_many :created_projects, :class_name => "Project", :foreign_key => :creator_id

  has_many :expenses
  has_many :rentals
  has_many :workinghours
  has_many :revenues

  attr_accessible :email, :username, :password, :password_confirmation, :assigned_projects_attributes

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  VALID_USERNAME_REGEX = /^[a-zA-Z\d_\-]+$/
  VALID_EMAIL_REGEX    = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :username, presence: true, format: { with: VALID_USERNAME_REGEX, message: "is invalid (no blank space allowed )" }, length: { minimum: 3, maximum: 50 }, uniqueness: true
  validates :email,    presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6 }

  def User.new_remember_token
  	SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
  	Digest::SHA1.hexdigest(token.to_s)
  end

  private

  	def create_remember_token
  		self.remember_token = User.encrypt(User.new_remember_token)
  	end

end
