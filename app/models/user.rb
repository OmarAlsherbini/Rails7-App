class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :user_event
  has_many :events, through: :user_event  
  before_create :add_jti
  
  def add_jti
    self.jti ||= SecureRandom.uuid
  end

end
