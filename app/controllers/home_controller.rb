# frozen_string_literal: true

class HomeController < ApplicationController
  def health_error
    raise StandardError, 'test error: it is fine! chess results'
  end

  def health; end
end
