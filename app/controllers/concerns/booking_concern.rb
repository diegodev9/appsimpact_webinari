module BookingConcern
  extend ActiveSupport::Concern

  def booking_stripe(customer, card_token_params, no_of_tickets, workshop)
    @stripe_service = StripeService.new
    @stripe_customer = @stripe_service.find_or_create_customer(customer)
    @card = @stripe_service.create_stripe_customer_card(card_token_params, @stripe_customer)
    @amount_to_be_paid = no_of_tickets * workshop.registration_fee
    @charge = @stripe_service.create_stripe_charge(@amount_to_be_paid, @stripe_customer.id, @card.id, workshop)
  end
  
  def create_customer(customer_params)
    customer = Customer.new(customer_params)
    if customer.save
      @customer = customer
    else
      render workshop_path(workshop), alert: "There's been an error"
    end
  end
end