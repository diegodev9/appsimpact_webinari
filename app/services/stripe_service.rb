# frozen_string_literal: true

require 'stripe'

class StripeService
  def initialize
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    # Stripe.api_key = ENV['STRIPE_PUBLISHABLE_KEY'] # for testing cards
  end

  def stripe_retrieve(customer)
    Stripe::Customer.retrieve(customer.stripe_customer_id)
  end

  def stripe_create(customer)
    Stripe::Customer.create(
      { name: customer.full_name, email: customer.email, phone: customer.contact_number }
    )
  end

  def retrieve_or_create_stripe_customer(customer)
    customer.stripe_customer_id.present? ? stripe_retrieve(customer) : stripe_create(customer)
  end

  def update_customer_stripe_id(customer, stripe_customer)
    return if customer.stripe_customer_id.present?

    customer.update(stripe_customer_id: stripe_customer.id)
  end

  def create_card_token(params)
    Stripe::Token.create({
                           card: {
                             number: params[:card_number].to_s,
                             exp_month: params[:exp_month],
                             exp_year: params[:exp_year],
                             cvc: params[:cvv]
                           }
                         })
  end

  def create_stripe_customer_card(params, stripe_customer)
    if Rails.env.production?
      token = create_card_token(params)
      Stripe::Customer.create_source(
        stripe_customer.id,
        { source: token.id }
      )
    else
      Stripe::Customer.create_source(
        stripe_customer.id,
        { source: 'tok_amex' }
      )
    end
  end

  def create_stripe_charge(amount_to_be_paid, stripe_customer_id, card_id, workshop)
    Stripe::Charge.create({
                            amount: amount_to_be_paid * 100,
                            currency: 'usd',
                            source: card_id,
                            customer: stripe_customer_id,
                            description: "Amount $#{amount_to_be_paid} charged for #{workshop.name}"
                          })
  end

  def create_stripe_refund(stripe_charge_id, amount)
    Stripe::Refund.create({
                            charge: stripe_charge_id,
                            amount: amount * 100
                          })
  end

  def find_or_create_customer(customer)
    stripe_customer = retrieve_or_create_stripe_customer(customer)
    update_customer_stripe_id(customer, stripe_customer)
    stripe_customer
  end
end
