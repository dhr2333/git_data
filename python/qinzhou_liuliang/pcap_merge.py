# coding=utf-8
import sys
import os
import time
from operator import itemgetter

pcap_path = ''
merge_size = 30


def get_file_list():
    array_list = []
    for top, dirs, nondirs in os.walk(pcap_path):
        for item in nondirs:
            if ".pcap" not in item \
                    or 'dhcp' in item \
                    or 'temp' in item:
                continue
            file_item = []
            file_path = os.path.join(top, item)
            file_item.append(item)
            file_item.append(file_path)
            file_time = float(item.split('_')[0])
            file_item.append(time.strftime("%Y-%m-%d_%H:%M:%S_dhcp.pcap", time.localtime(file_time)))
            array_list.append(file_item)
    return sorted(array_list, key=itemgetter(0))


if __name__ == '__main__':
    if len(sys.argv) == 3:
        pcap_path = str(sys.argv[1])
        merge_size = int(sys.argv[2])
    else:
        print("使用: python pcap_merge.py 路径 合并文件数(多少文件合并一次)")
        exit(-1)

    while True:
        file_list = []
        file_list = get_file_list()
        merge_input = ''
        merge_file_name = ''
        merge_list = []
        count = 0
        if len(file_list) < merge_size:
            time.sleep(1)
            continue
        for item in file_list:
            if count >= merge_size:
                break
            if len(merge_input) > 0:
                merge_input += " "
            merge_input += item[1]
            merge_list.append(item[1])
            if merge_file_name == '':
                merge_file_name = item[2]
            count += 1
        if len(merge_input) == 0:
	    time.sleep(1)
            continue

        cmd = 'mergecap -a -w ' + os.path.join(pcap_path, 'dhcp_temp.pcap') + " " + merge_input
        print(cmd)
        ret = os.system(cmd)
        cmd = 'mv ' + os.path.join(pcap_path, 'dhcp_temp.pcap') + " " + os.path.join(pcap_path, merge_file_name)
        print(cmd)
        ret = os.system(cmd)
        for item in merge_list:
            cmd = "rm -rf " + item
            ret = os.popen(cmd)
            ret.read()
	time.sleep(1)

