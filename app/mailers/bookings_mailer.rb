# frozen_string_literal: true
require 'rqrcode'

class BookingsMailer < ApplicationMailer
  def booking_confirmation(booking)
    qrcode = RQRCode::QRCode.new(booking_root_url(booking.id))
    @svg = qrcode.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 6,
      standalone: true,
      use_path: true
    )

    @booking = booking
    @customer = booking.customer
    @workshop = booking.workshop
    mail to: @customer.email, subject: "Booking confirmation for #{@workshop.name}"
  end

  private

  def booking_root_url(booking_id)
    return "http://localhost:3000/bookings/#{booking_id}/booking_details" if Rails.env.development?

    # TODO: prepare the PROD URL
  end
end
