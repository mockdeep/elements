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

  scope :roots, where(:parent_id => nil)
  scope :children, where('parent_id IS NOT NULL')

  def self.leafs
    where(<<-SQL)
      id NOT IN (
        SELECT parent_id FROM elements
        WHERE parent_id IS NOT NULL )
    SQL
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

end
