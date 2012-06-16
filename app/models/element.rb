require 'uuid_helper'

class Element < ActiveRecord::Base
  include UUIDHelper

  attr_accessible :title, :starts_at, :due_at, :value, :urgency

  belongs_to :user
  belongs_to :parent, :class_name => 'Element'
  has_many   :children,
    :class_name => 'Element',
    :foreign_key => :parent_id,
    :dependent => :destroy

  before_save :update_rank

  validates_presence_of :title, :user

  scope :roots, where('parent_id IS NULL')
  scope :children, where('parent_id IS NOT NULL')

  def self.leafs
    parent_ids = children.collect(&:parent_id)
    if parent_ids.empty?
      all
    else
      where('id NOT IN (?)', children.collect(&:parent_id))
    end
  end

  def self.ranked(direction = :desc)
    direction = :asc unless direction.to_sym == :desc
    order("rank #{direction}")
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

  def update_rank
    self.rank = (Math.sqrt(value**2 + urgency**2) * 100).round
  end

  def to_s
    title
  end

  def inspect
    title
  end
end
