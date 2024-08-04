# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @upcoming_workshop = Workshop.upcoming_workshops
    @past_workshop = Workshop.past_workshops
  end
end
