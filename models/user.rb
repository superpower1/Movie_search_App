class User < ActiveRecord::Base
  has_secure_password
  validates :email, uniqueness: true
  validates :name, :password, :email, presence: true
end
