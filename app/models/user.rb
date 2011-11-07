require 'uuid_helper'

class User < ActiveRecord::Base
  include UUIDHelper
  validates_presence_of :email
  validates_presence_of :username
end
