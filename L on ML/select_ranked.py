def select(file, number):
    f = open(file, "r")
    list_raw = f.readlines()
    list_dat = []
    for i in list_raw:
        list_1 = []
        s = i.strip('\n').split('\t')
        for j in (s[0], s[2]):
            m = eval(j)
            list_1.append(m)
        list_1.append(s[1])
        list_dat.append(list_1)
    sorted_list = sorted(list_dat, key=lambda x: x[1], reverse=True)
    sorted_list = sorted_list[:number]
    for n in range(len(sorted_list)):
        print("排名" + str(n + 1) + "的模型是: ", end = '')
        print(sorted_list[n])

select("Cancer versus ASD_Cancer.txt", 5)