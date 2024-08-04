class Refund < ApplicationRecord
  belongs_to :customer
  belongs_to :booking
  
  scope :accepted_refunds_for_booking, ->(booking_id) { where(state: 'accepted', booking_id:) }
  scope :successful_refunds_for_booking, ->(booking_id) { where(state: 'success', booking_id:) }
  scope :rejected_refunds_for_booking, ->(booking_id) { where(state: 'rejected', booking_id:) }

  def refundable_amount(workshop, tickets)
    tickets.to_i * workshop.registration_fee
  end

  def remaining_tickets_for_refund
    booking.no_of_tickets - no_of_tickets
  end

  def remaining_amount_for_refund
    remaining_tickets_for_refund * ticket_fee
  end

  def ticket_fee
    booking.workshop.registration_fee
  end

  def eligible_refundable_sits
    booking.no_of_tickets - Refund.where(state: 'accepted', booking_id:)
                                  .where.not(id:)
                                  .sum(:no_of_tickets)
  end
end
