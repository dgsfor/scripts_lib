#!/bin/bash
#coding:utf-8

#全量备份和增量备份svn
#需要备份的目录文件有以下几个:
#	1.svn list http://192.168.100.50/svn/public/QA_Process
#	2.svn list http://192.168.100.50/svn/op
#	3.svn list http://192.168.100.50/svn/designPub
#	4.svn list http://192.168.100.50/svn/tester

#全量备份并加密
function allbk(){
	if [ $2 ]; then
		#查看最后一次提交的版本号
		laste_versionNum=`svn info http://192.168.100.50/svn/$1/$2 | grep Revision | awk -F": " '{print $2}'`
		#最后一次版本号写入文件
		echo $laste_versionNum > ./versionNum/$2_versionNum.txt
		echo "`date +%Y-%m-%d`,$2,开始备份" >> backup.log
		svnadmin dump -r 1:$laste_versionNum /home/svn/$1 > /home/svnbackup/$2/$2-fullbackup-`date +%Y-%m-%d`
		echo "`date +%Y-%m-%d`,$2,结束备份" >> backup.log
		echo "`date +%Y-%m-%d`,$2,开始加密" >> backup.log
		/bin/expect > /dev/null 2>&1 <<-EOF
		spawn openssl aes256 -e -in /home/svnbackup/$2/$2-fullbackup-`date +%Y-%m-%d` -out /home/svnbackup/$2/$2-fullbackup-`date +%Y-%m-%d`.aes
		expect "*enter aes-256-cbc encryption password:"
		send "JZujNnaY7J47jU8N\r"
		expect "*#"
		expect "*Verifying - enter aes-256-cbc encryption password:"
		send "JZujNnaY7J47jU8N\r"
		expect "*#"
		exit
		expect eof
		EOF
		echo "`date +%Y-%m-%d`,$2,加密完成" >> backup.log
	else
		#查看最后一次提交的版本号
		laste_versionNum=`svn info http://192.168.100.50/svn/$1 | grep Revision | awk -F": " '{print $2}'`
		#最后一次版本号写入文件
		echo $laste_versionNum > ./versionNum/$1_versionNum.txt
		#进行全量备份
		echo "`date +%Y-%m-%d`,$1,开始备份" >> backup.log
		svnadmin dump -r 1:$laste_versionNum /home/svn/$1 > /home/svnbackup/$1/$1-fullbackup-`date +%Y-%m-%d`
		echo "`date +%Y-%m-%d`,$1,结束备份" >> backup.log
		echo "`date +%Y-%m-%d`,$1,开始加密" >> backup.log
		/bin/expect > /dev/null 2>&1 <<-EOF
                spawn openssl aes256 -e -in /home/svnbackup/$1/$1-fullbackup-`date +%Y-%m-%d` -out /home/svnbackup/$1/$1-fullbackup-`date +%Y-%m-%d`.aes
                expect "*enter aes-256-cbc encryption password:"
                send "JZujNnaY7J47jU8N\r"
                expect "*#"
                expect "*Verifying - enter aes-256-cbc encryption password:"
                send "JZujNnaY7J47jU8N\r"
                expect "*#"
                exit
                expect eof
		EOF
		echo "`date +%Y-%m-%d`,$1,加密完成" >> backup.log
	fi
}
#增量备份和加密
function increbk(){
	if [ $2 ];then
		#上一次的版本号
		last_versionNum=`cat /root/svn_toHuaWeiYun/svn_databk/svn_script/versionNum/$2_versionNum.txt`
		#最新的版本号
		new_versionNum=`svn info http://192.168.100.50/svn/$1/$2 | grep Revision | awk -F": " '{print $2}'`
		if [ $last_versionNum -eq $new_versionNum ];then
			echo "`date +%Y-%m-%d`,$2,无变化，不用备份" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
		else
			echo "`date +%Y-%m-%d`,$2,开始备份" >>/root/svn_toHuaWeiYun/svn_databk/svn_script/ backup.log
			echo $new_versionNum > /root/svn_toHuaWeiYun/svn_databk/svn_script/versionNum/$2_versionNum.txt
                        svnadmin dump -r $last_versionNum:$new_versionNum /home/svn/$1 --incremental > /home/svnbackup/$2/$2-increbackup-`date +%Y-%m-%d`
                        echo "`date +%Y-%m-%d`,$2,开始加密" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
                        /bin/expect > /dev/null 2>&1 <<-EOF
                        spawn openssl aes256 -e -in /home/svnbackup/$2/$2-increbackup-`date +%Y-%m-%d` -out /home/svnbackup/$2/$2-increbackup-`date +%Y-%m-%d`.aes
                        expect "*enter aes-256-cbc encryption password:"
                        send "JZujNnaY7J47jU8N\r"
                        expect "*#"
                        expect "*Verifying - enter aes-256-cbc encryption password:"
                        send "JZujNnaY7J47jU8N\r"
                        expect "*#"
                        exit
                        expect eof
			EOF
                        echo "`date +%Y-%m-%d`,$2,加密完成" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
		fi
	else
		#上一次的版本号
		last_versionNum=`cat /root/svn_toHuaWeiYun/svn_databk/svn_script/versionNum/$1_versionNum.txt`
		#最新的版本号
		new_versionNum=`svn info http://192.168.100.50/svn/$1 | grep Revision | awk -F": " '{print $2}'`
		if [ $last_versionNum -eq $new_versionNum ];then
                        echo "`date +%Y-%m-%d`,$1,无变化，不用备份" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
                else
                        echo "`date +%Y-%m-%d`,$1,开始备份" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
			echo $new_versionNum > /root/svn_toHuaWeiYun/svn_databk/svn_script/versionNum/$1_versionNum.txt
			svnadmin dump -r $last_versionNum:$new_versionNum /home/svn/$1 --incremental > /home/svnbackup/$1/$1-increbackup-`date +%Y-%m-%d`
			echo "`date +%Y-%m-%d`,$1,开始加密" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
			/bin/expect > /dev/null 2>&1 <<-EOF
               		spawn openssl aes256 -e -in /home/svnbackup/$1/$1-increbackup-`date +%Y-%m-%d` -out /home/svnbackup/$1/$1-increbackup-`date +%Y-%m-%d`.aes
               		expect "*enter aes-256-cbc encryption password:"
               		send "JZujNnaY7J47jU8N\r"
               		expect "*#"
               		expect "*Verifying - enter aes-256-cbc encryption password:"
               		send "JZujNnaY7J47jU8N\r"
               		expect "*#"
               		exit
               		expect eof
			EOF
			echo "`date +%Y-%m-%d`,$1,加密完成" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
               	fi
	fi
}
#全量备份函数调用
#echo "`date +%Y-%m-%d`,开始进行全量备份" >> backup.log
#allbk public QA_Process
#allbk op
#allbk designPub
#allbk tester
#echo "`date +%Y-%m-%d`,全量备份完成" >> backup.log
#echo "--------------------------------------------" >> backup.log

#增量备份函数调用
echo "`date +%Y-%m-%d`,开始进行增量备份" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
increbk public QA_Process
increbk op
increbk designPub
increbk tester
echo "`date +%Y-%m-%d`,增量备份完成" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log
echo "--------------------------------------------" >> /root/svn_toHuaWeiYun/svn_databk/svn_script/backup.log

