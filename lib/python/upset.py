"""
games.csv
からupsetがどれくらいあるかを調べる
"""
import csv
import matplotlib.pyplot as plt
from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Hiragino Maru Gothic Pro']
from datetime import datetime

SPAN = 100

def read_data(from_year=0, until_year=2030):
    diffs = [] # [(diff, stronger_point)]
    with open("games.tsv", "r") as f:
        reader = csv.reader(f, delimiter="\t")
        # header = next(reader)  # skip header
        for row in reader:
            start_at = datetime.strptime(row[8], "%Y-%m-%d")
            if start_at.year < from_year or start_at.year > until_year:
                continue
            white = int(row[2])
            black = int(row[5])
            if white < 400 or black < 400:
                continue
            diff = abs(white - black)
            point = float(row[7])
            if white <= black:
                point = 1 - point

            diffs.append((diff, point))
    return diffs

def to_hash(diffs):
    data = {} # data for stronger player,  {max_diff: {win: count, draw: count, loss: count}}
    for i in range(30):
        data[i] = {"win": 0, "draw": 0, "loss": 0}
    for di in diffs:
        d = di[0] # rating difference
        point = di[1] # point for the stronger player
        a = d // SPAN
        if a in data:
            if point == 1:
                data[a]["win"] += 1
            elif point == 0:
                data[a]["loss"] += 1
            elif point == 0.5:
                data[a]["draw"] += 1
            else:
                print(f"error unexpected point = {point}")
        else:
            print(f'error: no a = {a}')
    print(data)
    return data

def write_csv(diff_hash):
    head = ["レーティング差", "レーティングが高いプレーヤーの勝ち", "引分", "レーティングが高いプレーヤーの負け"]
    with open('diff.csv', "w") as f:
        writer = csv.writer(f, lineterminator='\n')  # set new line code
        writer.writerow(head)
        
        for i in range(30):
            l = [f"{i*100}~{(i+1)*100}", diff_hash[i]["win"], diff_hash[i]["draw"], diff_hash[i]["loss"]]
            writer.writerow(l)

def graph(diff_hash_list):
    for j, diff_hash_name in enumerate(diff_hash_list):
        diff_hash = diff_hash_name[0]
        name = diff_hash_name[1]
        avg_points = []
        x_data = []
        for i in range(7):
            d = diff_hash[i]
            total = d["win"] + d['draw'] + d['loss']
            if total == 0:
                avg = 0
            else:
                avg = (d["win"] * 1 + d["draw"] * 0.5) / total
            avg_points.append(avg)
            x_data.append(i * SPAN + SPAN / 2 - 10 + 10 * j)
            # x_data.append(i * SPAN + SPAN / 2 - 25 + 50 * i)
        plt.bar(x_data, avg_points, width=10, label=name)
    expect_points = [0.58, 0.71, 0.81, 0.89, 0.94, 0.97, 0.99]
    plt.plot(x_data, expect_points, "-or", label="期待値")
    plt.title('レーティングが高いプレーヤーが獲得したポイントの平均')
    plt.xlabel('レーティング差')

    plt.legend()
    # plt.show()
    plt.savefig('upset.png')

if __name__ == '__main__':
    data_all = read_data()
    data_all = to_hash(data_all)
    data_2022 = read_data(until_year=2022)
    data_2022 = to_hash(data_2022)
    data_2023 = read_data(from_year=2023)
    data_2023 = to_hash(data_2023)
    # write_csv(data)
    graph([(data_all, "全期間"), (data_2022, "2022年以前"), (data_2023, "2023年以降")])