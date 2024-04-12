# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # rubocop:disable Naming/AccessorMethodName
  def set_header_page(page)
    @header_page = page
  end
  # rubocop:enable Naming/AccessorMethodName
end
