# frozen_string_literal: true

module ApplicationHelper

  def flash_class(level)
    case level
    when :notice then 'alert alert-success'
    when :alert then 'alert alert-danger'
    else
      'alert alert-wwarning'
    end
  end
end
