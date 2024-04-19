"""
games.csv
からupsetがどれくらいあるかを調べる
"""
import csv
import matplotlib.pyplot as plt
from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Hiragino Maru Gothic Pro']


def read_data():
    diffs = [] # [(diff, stronger_point)]
    with open("games.tsv", "r") as f:
        reader = csv.reader(f, delimiter="\t")
        header = next(reader)  # skip header
        for row in reader:
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
    print('graph')
    span = 100
    data = {} # data for stronger player,  {max_diff: {win: count, draw: count, loss: count}}
    for i in range(30):
        data[i] = {"win": 0, "draw": 0, "loss": 0}
    for di in diffs:
        d = di[0]
        point = di[1] # point for the stronger player
        a = d // span
        if a in data:
            if point == 1:
                data[a]["win"] += 1
            elif point == 0:
                data[a]["loss"] += 1
            elif point == 0.5:
                data[a]["draw"] += 1
            else:
                print(f"error unexpected point = {point}")
            pass
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

def graph(diff_hash):
    print()
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
        x_data.append(i * 100 + 50)
    plt.bar(x_data, avg_points, width=50)
    expect_points = [0.58, 0.71, 0.81, 0.89, 0.94, 0.97, 0.99]
    plt.plot(x_data, expect_points, "-or", label="期待値")
    plt.title('レーティングが高いプレーヤーが獲得したポイントの平均')
    plt.xlabel('レーティング差')

    plt.legend()
    # plt.show()
    plt.savefig('upset.png')

if __name__ == '__main__':
    print('hello python')
    data = read_data()
    data = to_hash(data)
    # write_csv(data)
    graph(data)