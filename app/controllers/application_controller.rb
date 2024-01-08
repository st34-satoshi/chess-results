# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def set_header_page(page)
    @header_page = page
  end
end
