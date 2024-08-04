# frozen_string_literal: true

class Booking < ApplicationRecord
  has_many :refunds
  belongs_to :customer
  belongs_to :workshop

  validates :order_number, presence: true, uniqueness: true

  before_validation :generate_order_number # generate_order_number antes de la validacion de order_number
  after_create :update_workshop_sit_count

  def update_workshop_sit_count
    workshop.update(remaining_sits: workshop.total_sits - no_of_tickets)
  end

  def generate_order_number
    # SecureRandom es un generador de caracteres alfanumericos de ruby
    self.order_number = "BOOKING-#{SecureRandom.hex(5).upcase}"
  end

  def refundable?
    workshop.start_date > Date.today
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[amount_paid created_at customer_id id id_value no_of_tickets order_number stripe_transaction_id updated_at workshop_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[customer refunds workshop]
  end
end
