# frozen_string_literal: true

class GameSearchParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :name, :string, default: nil
  attribute :ncs_id, :string, default: nil
  attribute :tournament, :string, default: nil
  attribute :date_from, :date, default: nil
  attribute :date_until, :date, default: nil

  def initialize(params)
    super(params.permit(:name, :ncs_id, :tournament, :date_from, :date_until))
  end

end
