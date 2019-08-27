class User < ApplicationRecord
  after_initialize :generate_auth_token

  has_many :posts

  validates :name, presence: true
  validates :email, presence: true
  validates :auth_token, presence: true


  def generate_auth_token
    self.auth_token = TokenGenerationService.generate unless auth_token.present?
  end
end
