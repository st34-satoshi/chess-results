# Pythonでデータを処理する

## 準備
- `pip install -r requirements.txt`

### games.tsv
DBのgamesテーブルをtsvにする
- ログイン `mysql -h localhost -P 3309 -uroot -p --protocol=tcp`
- dump to tsv
```
SELECT * FROM chess_results_development.games
INTO OUTFILE '/var/lib/mysql-files/games.tsv'
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n';
```
- コンテナ内からローカルにコピー `docker cp chess-results-db-1:/var/lib/mysql-files/games.tsv ./`

## 実行
### Upset
- prepare `games.tsv`
- `python upset.py`

![upset.png](upset.png)

### 白の勝率
- prepare `games.tsv`
- `python white_win_rate.py`

![white_win_rate.png](white_win_rate.png)