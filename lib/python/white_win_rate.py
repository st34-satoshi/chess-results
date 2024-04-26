"""
games.csv
から白の勝率を調べる
"""
import csv
import matplotlib.pyplot as plt
from matplotlib import rcParams
rcParams['font.family'] = 'sans-serif'
rcParams['font.sans-serif'] = ['Hiragino Maru Gothic Pro']


def read_data():
    win = 0
    draw = 0
    loss = 0
    with open("games.tsv", "r") as f:
        reader = csv.reader(f, delimiter="\t")
        header = next(reader)  # skip header
        for row in reader:
            point = float(row[7])
            if point == 1:
                win += 1
            elif point == 0:
                loss += 1
            elif point == 0.5:
                draw += 1
            else:
                print(f'error: point = {point}')
    return [win, draw, loss]

def graph(win, draw, loss):
    print(f"{win=}, {draw=}, {loss=}")
    labels = ['黒勝ち', '引分', '白勝ち']
    data = [loss, draw, win]
    plt.pie(data, labels=labels, autopct='%1.1f%%', startangle = 90)
    plt.title('手番による勝率')

    plt.legend()
    # plt.show()
    plt.savefig('white_win_rate.png')

if __name__ == '__main__':
    data = read_data()
    # write_csv(data)
    graph(data[0], data[1], data[2])