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
  attribute :time_type, :string, default: "すべて"

  def initialize(params)
    super(params.permit(:name, :ncs_id, :tournament, :date_from, :date_until, :time_type))
  end

  def valid_parameter?
    ok = true
    Rails.logger.info name
    unless valid_name?
      errors.add(:base, 'プレーヤー名に記号などの文字は使えません。日本語か英数字だけを入力してください。')
      ok = false
    end
    unless valid_tournament?
      errors.add(:base, '大会名に記号などの文字は使えません。日本語か英数字だけを入力してください。')
      ok = false
    end
    ok
  end

  def valid_name?
    return false if name.present? && name.match(%r{[!@#$%^&*()\=+{};:'",.<>/?\\|~`]}).present?

    true
  end

  def valid_tournament?
    return false if tournament.present? && tournament.match(%r{[!@#$%^&*()\=+{};:'",.<>/?\\|~`]}).present?

    true
  end
end
