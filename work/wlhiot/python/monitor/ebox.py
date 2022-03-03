from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import requests
import json
import paramiko

# 创建 WebDriver 对象
ebox = webdriver.Chrome()
picture_time = time.strftime("%Y-%m-%d", time.localtime(time.time()))
private_key = paramiko.RSAKey.from_private_key_file(r'C:\Users\Dai_Haorui\.ssh\id_rsa')


# 主程序，包含自动登录
def main(project):
    # 最大等待时间，每隔0.5S去定位查询一下元素是否存在，只针对element和elements定位操作
    wd = project
    wd.implicitly_wait(10)
    # 调用WebDriver 对象的get方法 可以让浏览器打开指定网址
    wd.get('http://ebox.xxxxxx.com/login?redirect=%2Fhome')

    # 选中登录框的元素
    button = wd.find_element(By.CLASS_NAME, 'login-form')
    # 输入用户名
    user = button.find_element(By.CLASS_NAME, 'el-input--prefix')
    user1 = user.find_element(By.CLASS_NAME, 'el-input__inner')
    user1.send_keys('xxxxxx')
    # 输入密码
    passwd = button.find_element(By.CLASS_NAME, 'el-input--suffix')
    passwd1 = passwd.find_element(By.CLASS_NAME, 'el-input__inner')
    passwd1.send_keys('xxxxxx')
    # 登录
    button.find_element(By.CLASS_NAME, 'el-button--primary').click()
    time.sleep(8)


# 截图
def screenshot():
    try:
        ebox.get_screenshot_as_file(r'D:\work\Python\wlhiot\Picture\ebox_' + picture_time + '.png')
        print("截图成功！！！")
    except BaseException as msg:
        print(msg)


# 推送给linux服务器
def push():
    # dev
    # transport = paramiko.Transport(('192.168.254.29', 22))
    # transport.connect(username='xxx', password='xxxxxx')
    # pro
    transport = paramiko.Transport(('xxx.xxx.xxx.xxx', 22))
    transport.connect(username='xxx', pkey=private_key)

    sftp = paramiko.SFTPClient.from_transport(transport)
    try:
        # dev
        # sftp.put(r'D:\work\Python\wlhiot\Picture\ebox_' + picture_time + '.png',
        #          '/usr/local/wlhiot/mount/nginx/QR/html/sftp/ebox/ebox_' + picture_time + '.png')
        # print("推送成功！！！")
        # pro
        sftp.put(r'D:\work\Python\wlhiot\Picture\ebox_' + picture_time + '.png',
                 '/usr/local/wlhiot/mount/nginx/QR/html/sftp/ebox.png')
        print("推送成功！！！")
    except BaseException as msg:
        print(msg)

    transport.close()  # 关闭连接


# 发送dingtalk
def send():
    url = 'https://oapi.dingtalk.com/robot/send?access_token=' \
          'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

    headers = {'Content-Type': 'application/json;charset=utf-8'}

    data = {
        "msgtype": "markdown",
        "markdown": {
            "title": "wlhiot每日监控",
            "text": "#### 监控信息 \n"
                    " > ![screenshot](http://usermanual.xxxxxx.com:8100/sftp/ebox.png)\n"
        },

    }
    r = requests.post(url=url, headers=headers, data=json.dumps(data))
    print(r.json())


main(ebox)
screenshot()
push()
send()
ebox.quit()
