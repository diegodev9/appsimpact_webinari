# frozen_string_literal: true

class Workshop < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :bookings
  has_many :customers, through: :bookings

  validates :name, :description, presence: true
  validates :start_date, :end_date, :start_time, :end_time, presence: true
  validates :total_sits, :registration_fee, presence: true, numericality: true
  validates :end_date, comparison: { greater_than: :start_date, message: 'Can not be before start date' }

  scope :upcoming_workshops, -> { where('start_date > ?', Date.today) }
  scope :past_workshops, -> { where('end_date < ?', Date.today) }

  def total_duration
    "From #{start_date} to #{end_date}"
  end

  def daily_workshop_hours
    "#{((start_time.to_time - end_time.to_time) / 1.hour).abs} hours"
  end

  def daily_duration
    "Everyday #{start_time} to #{end_time} (#{daily_workshop_hours})"
  end

  def is_upcoming_workshop?
    start_date > Date.today
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[created_at description end_date end_time id id_value name registration_fee remaining_sits slug start_date start_time total_sits updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[bookings customers]
  end
end
