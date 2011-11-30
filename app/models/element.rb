require 'uuid_helper'

class Element < ActiveRecord::Base
  include UUIDHelper

  belongs_to :user
  belongs_to :parent, :class_name => 'Element'
  has_many   :children, :class_name => 'Element', :foreign_key => :parent_id

  validates_presence_of :title

  scope :root_elements, :conditions => 'parent_id IS NULL'
end
