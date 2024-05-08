# frozen_string_literal: true

class GameSearchParameter
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveRecord::AttributeAssignment
  include ActiveRecord::AttributeMethods::Write

  attribute :name, :string, default: nil
  attribute :opponent, :string, default: nil
  attribute :ncs_id, :string, default: nil
  attribute :tournament, :string, default: nil
  attribute :date_from, :date, default: nil
  attribute :date_until, :date, default: nil
  attribute :time_type, :string, default: "すべて"

  def initialize(params)
    super(params.permit(:name, :opponent, :ncs_id, :tournament, :date_from, :date_until, :time_type))
  end

  def valid_parameter?
    ok = true
    unless valid_name?(name)
      errors.add(:base, 'プレーヤー名に記号などの文字は使えません。日本語か英数字だけを入力してください。')
      ok = false
    end
    unless valid_name?(opponent)
      errors.add(:base, '対戦相手名に記号などの文字は使えません。日本語か英数字だけを入力してください。')
      ok = false
    end
    unless valid_tournament?
      errors.add(:base, '大会名に記号などの文字は使えません。日本語か英数字だけを入力してください。')
      ok = false
    end
    ok
  end

  def valid_name?(name_string)
    return false if name_string.present? && name_string.match(%r{[!@#$%^&*()\=+{};:'",.<>/?\\|~`]}).present?

    true
  end

  def valid_tournament?
    return false if tournament.present? && tournament.match(%r{[!@#$%^&*()\=+{};:'",.<>/?\\|~`]}).present?

    true
  end
end
