# coding=utf-8
import sys
import os
import time
from operator import itemgetter

raw_path = ""
save_path = ""
filter_rule = ""
file_time = 0
file_num = 0


def get_file_list():
    array_list = []
    for top, dirs, nondirs in os.walk(raw_path):
        for item in nondirs:
            if ".pcap" not in item:
                continue
            file_item = []
            file_path = os.path.join(top, item)
            if os.path.exists(file_path):
                file_item.append(item)
                file_item.append(file_path)
                file_item.append(float(item.split("_")[0]))
                file_item.append(int(item.split("_")[1].split(".")[0]))
                array_list.append(file_item)
    # print(array_list)
    return sorted(array_list, key=lambda s: s[0])


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    if len(sys.argv) == 3:
        raw_path = str(sys.argv[1])
        save_path = str(sys.argv[2])
    else:
        print("使用: python pcap_filter.py 原包路径(到pcap上一级) 存储DHCP路径")
        exit(-1)
        # pcap_rule = str(sys.argv[3])
    print('raw pcap path:' + raw_path)
    print('save pcap path:' + save_path)
    # print('filter rule:' + filter_rule)

    while True:
        file_list = []
        file_list = get_file_list()

        for item in file_list:
            if file_time > item[2] or \
                    (file_time == item[2] and file_num >= item[3]):
                # print(str(file_time) + " " + str(item[2]) + " : " + str(file_num) + ":" + str(item[3]))
                continue

            cmd = "tcpdump -r " + item[1] + ' -w ' + os.path.join(save_path, 'temp.pcap') \
                  + " host  42.0.1.1 "
            print(cmd)
            os.system(cmd)
            cmd = "mv " + os.path.join(save_path, 'temp.pcap') + " " + os.path.join(save_path, item[0])
            print(cmd)
            os.system(cmd)
            file_time = item[2]
            file_num = item[3]
	time.sleep(1)

