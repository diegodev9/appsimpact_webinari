# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@webinari.com'
  layout 'mailer'
end
