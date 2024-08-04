class Admin::DashboardController < AdminController
  def index
    set_counts
    set_revenue_earned
    set_refundable_bookings
    set_active_refunds
  end

  private

  def set_counts
    @workshop_count = Workshop.count
    @upcoming_workshop_count = Workshop.upcoming_workshops.count
    @past_workshop_count = Workshop.past_workshops.count
    @customer_count = Customer.count
    @booking_count = Booking.count
  end

  def set_revenue_earned
    @revenue_earned = Booking.sum(:amount_paid) # obtiene todos los amount_paid de booking y los suma
  end

  def set_refundable_bookings
    @refundable_bookings = Booking.includes(:workshop)
                                  .where('workshops.start_date >= ?', Date.today)
                                  .references(:workshops)
  end

  def set_active_refunds
    @active_refunds = Refund.includes(:booking)
                            .where('bookings.workshop_id IN (?) AND refunds.state = ?', Workshop.upcoming_workshops.ids, 'accepted')
                            .references(:booking)
  end
end