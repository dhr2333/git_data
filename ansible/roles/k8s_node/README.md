Role Name
=========

Initializing the server. include Basic tools install, optimizing ssh, disable SELinux, Docker install and configurtion.

Requirements
------------

The Inventory has been configured. such as:

cat /etc/ansible/hosts

[test]
192.168.254.34  hostname=k8s-node05
192.168.254.35  hostname=k8s-node06

Role Variables
--------------

None.

Dependencies
------------

None.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    $ ls -l
    total 4
    drwxr-xr-x 10 root root 154 2022-02-17 16:32 k8s_node
    -rw-r--r--  1 root root 154 2022-02-17 17:41 main.yml
    $ ansible-playbook main.yml

License
-------

BSD

Author Information
------------------

name: daihaorui

email: Dai_Haorui@163.com

wechat: Daihr2333