class Admin::RefundsController < AdminController
  include HandleErrors

  before_action :set_refund

  def process_refund
    @refund.amount_refunded = refund_amount
    create_stripe_refund
    update_refund
    redirect_to admin_dashboard_path, notice: 'Refund processed successfully'
  rescue Stripe::StripeError => e
    handle_stripe_error(e, admin_dashboard_path)
  end

  private

  def refund_amount
    @refund.refundable_amount(@refund.booking.workshop, @refund.no_of_tickets)
  end

  def create_stripe_refund
    stripe_service = StripeService.new
    stripe_charge_id = @refund.booking.stripe_transaction_id
    @stripe_refund = stripe_service.create_stripe_refund(stripe_charge_id, refund_amount)
  end

  def update_refund
    @refund.is_partial_refund = @refund.amount_refunded < @refund.booking.amount_paid
    @refund.stripe_refund_id = @stripe_refund.id
    @refund.state = 'success'
    @refund.save
  end

  def set_refund
    @refund = Refund.find(params[:id])
  end
end