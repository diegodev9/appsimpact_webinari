# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :bookings
  has_many :workshops, through: :bookings
  has_many :refunds

  validates :full_name, :contact_number, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.ransackable_attributes(auth_object = nil)
    %w[contact_number created_at email full_name id id_value stripe_customer_id updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[bookings refunds workshops]
  end
end
