class Admin::BookingsController < AdminController
  before_action :set_booking_with_parents, only: %i[show destroy]

  def index
    @find_booking = Booking.ransack(params[:q])
    @bookings = @find_booking.result.includes(:workshop, :customer)
  end

  def show; end

  def destroy
    @booking.destroy
    redirect_to admin_bookings_path, notice: 'Booking deleted successfully'
  end

  private

  def set_booking_with_parents
    @booking = Booking.find(params[:id])
    @customer = @booking.customer
    @workshop = @booking.workshop
  end
end