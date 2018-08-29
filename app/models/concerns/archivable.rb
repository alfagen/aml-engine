module Archivable
  extend ActiveSupport::Concern

  included do
    scope :archive, -> { where 'archived_at is not null' }
    scope :alive,   -> { where archived_at: nil }
  end

  def active?
    return false if respond_to?(:is_active) && !is_active
    alive?
  end

  def archive
    self.archived_at ||= Time.zone.now
  end

  def archive!
    archive
    save validate: false
  end

  def restore
    self.archived_at = nil
  end

  def restore!
    restore
    save validate: false
  end

  def archived?
    archived_at.present?
  end

  def alive?
    archived_at.nil?
  end

  def alive_presence
    alive? ? self : nil
  end
end
