require 'uuid_helper'
require 'constants'

class User < ActiveRecord::Base
  include UUIDHelper
  attr_accessor :password
  attr_accessible :email, :username, :password, :password_confirmation

  has_many :elements

  before_save :encrypt_password

  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_uniqueness_of :email
  validates_format_of :email, :with => Constants::EMAIL_REGEX

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    return nil unless user
    hash = BCrypt::Engine.hash_secret(password, user.password_salt)
    user.password_hash == hash ? user : nil
  end
end
