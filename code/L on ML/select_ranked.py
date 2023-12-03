def average(lst):
    if len(lst) == 0:
        return 0
    else:
        return sum(lst) / len(lst)

def select(file, number):
    f = open(file, "r")
    list_raw = f.readlines()
    f.close()
    list_dat = []
    for i in list_raw:
        list_1 = []
        s = i.strip('\n').rstrip('\t').split('\t')
        for j in (s[0], s[2]):
            m = eval(j)
            list_1.append(m)
        list_dat.append(list_1)
    sorted_list = sorted(list_dat, key=lambda x: average(x[1]), reverse=True)
    sorted_list_1 = sorted_list[:number]
    f = open("rank_model.txt", 'w')
    for n in range(len(sorted_list)):
        f.write("排名" + str(n + 1) + "的模型是: ")
        f.write(str(sorted_list[n][1]))
        f.write('\n')
    f.close()
    for n in range(len(sorted_list_1)):
        print("排名" + str(n + 1) + "的模型是: ", end = '')
        print(sorted_list_1[n][0],end = '\t')
        print("平均值是: ", end = '')
        print(average(sorted_list_1[n][1]), end = '\t')
        print(sorted_list_1[n][1])

select("L on ML/data/随机森林_Cancer_ASD_Cancer.txt", 20)