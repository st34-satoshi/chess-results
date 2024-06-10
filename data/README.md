# 対局結果のデータをcsv形式で保存する
このディレクトリ以下のファイルを読み込んでデータベースに追加する

# 修正方法
結果が違うことが後から分かった場合は手動で修正する。(良い感じのスクリプトが思いつかない)

1. 元のデータを修正する
2. ローカルやプロダクションに保存しているcsvデータを修正する
3. 本番環境でRailsからDBを修正する:
  - `docker compose -f docker-compose.production.yml exec web rails c`
  - find player: `Player.where("name_en LIKE ?", "%Tanaka Sato%")`
  - find game: `g = Game.where(white_id: 2).where(black_id: 3).where("start_at <= '2023-01-01'")`
  - update game `g.update(white_point: 1.0)`
4. playersテーブルとplayers_{year}テーブルを更新する