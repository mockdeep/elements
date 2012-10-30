require 'uuid_helper'
require 'constants'

class User < ActiveRecord::Base
  include UUIDHelper
  has_secure_password

  has_many :elements#TODO: , :dependent => :destroy

  validates_presence_of :email
  validates_presence_of :username
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email
  validates_format_of :email, :with => Constants::EMAIL_REGEX

  def self.authenticate(email, password)
    User.find_by_email(email).try(:authenticate, password)
  end
end
