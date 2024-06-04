# Chess Results
日本チェス連盟公式戦の記録

## Webページ
[日本チェス連盟公式戦データベース](https://results.japanchess.org)

## 開発
- `docker compose build`
- `docker compose run web rails db:create`
- `docker compose run web rails db:migrate`
- `docker compose up`
- `open http://localhost:3007`

### データの用意
対局結果が入ったcsvファイルを用意する

- (ダミーデータを使用する場合) `mkdir data/2024-ST && mv data/ex/2024-01-01.csv data/2024-ST/2024-01-02.csv`
- `docker compose exec web rake database:create_data`: 対局結果を保存する(実データだと15分かかる...)
- `docker compose exec web rake database:create_player_stats`: プレーヤーごとの統計情報を保存する
- `docker compose exec web rake database:create_year_player_ranking`: 年毎のプレーヤーのランキングテーブルを作成する(実データだと10分かかる...)
- `docker compose exec web rake 'database:create_year_player_ranking_in[2024]'`: 指定した年のプレーヤーのランキングテーブルを作成する
- `docker compose exec web rake database:add_pgn_moves`: すでに保存されている対局の棋譜を上書き保存する
- `docker compose exec web rake 'database:create_from_a_file[data/2024-ST/2024-01-01.csv]'`: ファイルを指定して対局結果を保存する

### pry
1. set `binding.pry`
1. check container id: `docker ps`
1. docker attach container_id
1. open browser
1. `exit`
1. Ctrl + q

### PR作成
- GitHubでプロジェクトをフォーク
- `git clone git@github.com:your_name/chess-results.git`
- `cd chess-results`
- `git checkout -b feature/xxx`
- some commits
- `docker compose exec web rubocop -A` check rubocop
- `git push origin feature/xxx`
- PRを作成する

## プロダクションデプロイ
- config/master.keyを本番環境に用意する
- `docker compose -f docker-compose.production.yml build`
- `docker compose -f docker-compose.production.yml up -d`
- `docker compose -f docker-compose.production.yml run web rails db:create RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1`
- `docker compose -f docker-compose.production.yml run web rails db:migrate:reset RAILS_ENV=production`