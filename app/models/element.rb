require 'uuid_helper'

class Element < ActiveRecord::Base
  include UUIDHelper

  belongs_to :user
  belongs_to :parent, :class_name => 'Element'

  has_many :children,
    :class_name => 'Element',
    :foreign_key => :parent_id,
    :dependent => :destroy

  validates :title, :user, :presence => true

  before_save :update_rank

  default_scope -> { where(:done_at => nil).includes(:children) }

  scope :roots, -> { where(:parent_id => nil) }
  scope :children, -> { where('parent_id IS NOT NULL') }

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
      children.update_all(:done_at => done_at)
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
