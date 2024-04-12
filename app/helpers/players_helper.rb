module PlayersHelper
  def ranking_kind_name(kind)
    d = {games: "対局数", win: "勝ち数", draw: "引分数", avg_rating: "相手平均レーティング"}
    kind = kind.to_sym
    return d[kind] if d.keys.include? kind
    ""
  end
end
