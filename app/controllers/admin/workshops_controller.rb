class Admin::WorkshopsController < AdminController
  before_action :set_workshop, only: %i[show destroy]

  def index
    @find_workshop = Workshop.ransack(params[:q])
    @workshops = @find_workshop.result
  end

  def new
    @workshop = Workshop.new
  end

  def create
    @workshop = Workshop.new(workshop_params)
    if @workshop.save
      redirect_to admin_workshops_path, notice: "Workshop created successfully"
    else
      render :new
    end
  end

  def show; end

  def destroy
    @workshop.destroy
    redirect_to admin_workshops_path, notice: "Workshop deleted successfully"
  end

  private

  def set_workshop
    @workshop = Workshop.friendly.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:name, :description, :start_date, :end_date, :start_time, :end_time, :total_sits, :remaining_sits, :registration_fee)
  end
end