#!/bin/bash
#
#主要部署公共组件:codis,zk,metaq,solr,nodejs

#部署codis注意事项
#1.首先环境变量用高权限账号添加好，/etc/profile
#2.修改startall.sh脚本，替换里面的ip地址

. /etc/init.d/functions

DEPLAY_PATH=/data
SOFT_PATH=/data/csoft
CODIS_CONFIG_PATH=/data/gopkg/src/github.com/wandoulabs/codis/goodsCache/config
SELF_IP=`hostname -I | awk -F" " '{print $1}'`

main_echo(){
	echo "************OPS 公共组件安装************"
	echo "1.zk"
	echo "2.codis"
	echo "3.metaq"
	echo "4.solr"
	echo "5.nodejs fis3 pm2"
	read -p "请选择要安装的组件：" num
	return $num
}

deplay_zk(){
	cd $DEPLAY_PATH
	tar xzvf  $SOFT_PATH/zookeeper-3.4.6.tar.gz -C $DEPLAY_PATH
	cd zookeeper-3.4.6/conf/ && cp zoo_sample.cfg zoo.cfg
	sed -i 's/dataDir=\/tmp\/zookeeper/dataDir=\/data\/zookeeper/g' zoo.cfg
	cd ../bin/ && ./zkServer.sh start
	echo -n "zk部署成功，并启动成功" && success
	echo ""
}

deplay_codis(){
	cd $DEPLAY_PATH
	tar xzvf $SOFT_PATH/go.tar.gz -C $DEPLAY_PATH
	tar xzvf $SOFT_PATH/gopkg.tar.gz -C $DEPLAY_PATH
	#echo "export GOROOT=/data/go" >> /etc/profile
	#echo "export GOROOT=/data/gopkg" >> /etc/profile
	#echo "PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$GOROOT/bin" >> /etc/profile
	sed -i "s/dashboard_addr=192\.168\.187\.133\:18088/dashboard_addr=$SELF_IP\:18088/g" $CODIS_CONFIG_PATH/config.ini
	sed -i "s/dashboard_addr=192\.168\.187\.133\:18088/dashboard_addr=$SELF_IP\:18088/g" $CODIS_CONFIG_PATH/config1.ini
	sed -i "s/dashboard_addr=192\.168\.187\.133\:18088/dashboard_addr=$SELF_IP\:18088/g" $CODIS_CONFIG_PATH/config2.ini
	cd $SOFT_PATH && ./startall.sh
}

deplay_metaq(){
	cd $DEPLAY_PATH
	tar xzvf $SOFT_PATH/metamorphosis-server-wrapper.tar.gz -C $DEPLAY_PATH
	sed -i "s/zk\.zkConnect=10\.170\.246\.225\:2181/zk\.zkConnect=$SELF_IP\:2181/g" metamorphosis-server-wrapper/conf/server.ini 
	cd metamorphosis-server-wrapper/bin/ && ./metaServer.sh start &
}

deplay_solr(){
	cd $DEPLAY_PATH
	cd dlsolr/webapps && rm ./* -rf
	cd $DEPLAY_PATH
	tar xzvf $SOFT_PATH/solr.tar.gz -C $DEPLAY_PATH/dlsolr/webapps/ && mv $DEPLAY_PATH/dlsolr/webapps/solr $DEPLAY_PATH/dlsolr/webapps/ROOT
	tar xzvf $SOFT_PATH/solr_home.tar.gz -C $DEPLAY_PATH
}

main_echo
case $num in
	1)
		deplay_zk
		;;
	2)
		deplay_codis
		;;
	3)
		deplay_metaq
		;;
	4)
		deplay_solr
		;;
	5)
		deplay_nodejs
		;;
	*)
		echo "输入有误，请重新输入！"
		;;
esac

