# Chess Results
日本チェス連盟公式戦の記録

## Webページ
[Chess Results](https://chess-results.stu345.com)

## 開発
- `docker compose build`
- `docker compose run web rails db:create`
- `docker compose run web rails db:migrate`
- `docker compose up`
- `open http://localhost:3007`

### データの用意
対局結果が入ったcsvファイルを用意する

- `docker compose exec web rake database:create_data`

### PR作成
- `git clone git@github.com:st34-satoshi/chess-results.git`
- `cd chess-results`
- `git checkout -b feature/xxx`
- some commits
- `docker compose exec web rubocop -A` check rubocop
- `git push origin feature/xxx`
- create a PR