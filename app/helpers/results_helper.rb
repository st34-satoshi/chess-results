# frozen_string_literal: true

module ResultsHelper
  def result_to_white_s(result)
    # floatの白の点数を受け取って 1-0, 1/2-1/2, 0-1に変換する
    return "1-0" if result == 1
    return "0-1" if result == 0
    return "1/2-1/2" if result == 0.5
    ""
  end

  def rating_format(rating)
    return rating if rating.positive?
    "UR"
  end
end
