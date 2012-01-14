require 'uuid_helper'

class Element < ActiveRecord::Base
  include UUIDHelper

  belongs_to :user
  belongs_to :parent, :class_name => 'Element'
  has_many   :children,
    :class_name => 'Element',
    :foreign_key => :parent_id,
    :dependent => :destroy

  validates_presence_of :title, :user

  scope :roots, :conditions => 'parent_id IS NULL'
  scope :children, :conditions => 'parent_id IS NOT NULL'

  def self.leafs
    where('id not in (?)', children.collect(&:parent_id))
  end

  def done=(done_var)
    if done_var
      self.done_at = Time.zone.now
      children.each do |child|
        child.done = true
        child.save
      end
    else
      self.done_at = nil
    end
  end
end
