# frozen_string_literal: true

class BookingsController < ApplicationController
  include BookingConcern
  include HandleErrors

  before_action :find_customer, only: :create
  before_action :find_workshop, only: :create

  def create
    @customer ||= create_customer(customer_params)
    process_booking(@customer, card_token_params, params[:no_of_tickets].to_i, @workshop)
    create_booking
    send_booking_notification

    redirect_to workshop_path(@workshop), notice: 'Your ticket has been booked'
  rescue Stripe::StripeError => e
    handle_stripe_error(e, workshop_path(@workshop))
  end

  def booking_details
    @booking = Booking.find(params[:id])
  end

  private

  def process_booking(customer, card_token, no_of_tickets, workshop)
    @charge = booking_stripe(customer, card_token, no_of_tickets, workshop)
  end

  def create_booking
    @booking = @workshop.bookings.create(
      customer_id: @customer.id,
      stripe_transaction_id: @charge.id,
      no_of_tickets: params[:no_of_tickets].to_i,
      amount_paid: @amount_to_be_paid
    )
  end

  def send_booking_notification
    BookingsMailer.booking_confirmation(@booking).deliver_now
  end

  def find_customer
    @customer = Customer.find_by(email: params[:email])
  end

  def find_workshop
    @workshop = Workshop.find(params[:workshop_id])
  end

  def customer_params
    params.permit(:full_name, :contact_number, :email)
  end

  def card_token_params
    params.permit(:card_number, :exp_year, :exp_month, :cvv)
  end
end
