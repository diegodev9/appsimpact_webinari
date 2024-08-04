module HandleErrors
  extend ActiveSupport::Concern

  def handle_stripe_error(error, redirection_url)
    redirect_to redirection_url, alert: error.message.to_s
  end
end