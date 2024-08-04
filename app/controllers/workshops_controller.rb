# frozen_string_literal: true

class WorkshopsController < ApplicationController
  def index
    @workshops = Workshop.upcoming_workshops
  end

  def show
    @workshop = begin
      Workshop.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to workshops_path, notice: 'Workshop not found'
    end
  end
end
