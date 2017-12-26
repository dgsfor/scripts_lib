#!/bin/bash
#
#作者：李彬
#联系方式：sicau_libin@163.com
#作用：
#   批量修改新环境的tomcat名字，以及相应的端口，附加修改回环地址以及过滤jar包
#如果使用，修改两个地方:
#   1.tomcat_ip.txt内容修改，依照execl表格进行
#   2.修改ssh端口为14588

cat tomcat_ip.txt | while read line
do
    IFS=" "  a=($line)
    HOSTNAME=${a[0]}
    HOSTIP=${a[1]}
    TOMCAT_NAME=${a[2]}
    SERVICE=${a[3]}
    DOWN_PORT=${a[4]}
    HTTP_PORT=${a[5]}
    AJP_PORT=${a[6]}
    echo -e "************\033[33m修改"${HOSTNAME}"的"${SERVICE}"微服务\033[0m**************"
    cat > order.sh<<EOF
#!/bin/bash
#
. /etc/init.d/functions
cd /data
echo -ne "\033[34m1、开始复制tomcat目录... \033[0m"
echo ""
cp ${TOMCAT_NAME} ${SERVICE} -R
echo -n "    复制tomcat目录成功..." && success
echo ""
echo -ne "\033[34m2、开始修改tomcat配置文件端口...\033[0m"
echo ""
sed -i 's/<Server port=*.*shutdown=\"SHUTDOWN\">/<Server port=\"${DOWN_PORT}\" shutdown=\"SHUTDOWN\">/g' ${SERVICE}/conf/server.xml
sed -i 's/<Connector port=*.*protocol=\"HTTP\/1\.1\"/<Connector port=\"${HTTP_PORT}\" protocol=\"HTTP\/1\.1\"/g' ${SERVICE}/conf/server.xml
sed -i 's/<Connector port=*.*protocol=\"AJP\/1\.3\"/<Connector port=\"${AJP_PORT}\" protocol=\"AJP\/1\.3\"/g' ${SERVICE}/conf/server.xml
echo -n "    修改tomcat配置文件端口成功" && success
echo ""
echo -ne "\033[34m3、开始修改tomcat配置文件回环地址... \033[0m"
echo ""
sed -i 's/protocol=\"AJP\/1\.3\"/address=\"127.0.0.1\" &/g' ${SERVICE}/conf/server.xml
if [ $? = 0 ];then
    echo -n "    "${HOSTNAME}--${HOSTIP}--${SERVICE}--"修改回环地址成功" && success
    echo ""
else
    echo -n "    "${HOSTNAME}--${HOSTIP}--${SERVICE}--"修改回环地址失败" && failure
    echo ""
fi
echo -ne "\033[34m4、开始修改tomcat配置文件过滤jar包... \033[0m"
echo ""
sed -i 's/xom-\*.jar/&,bcprov\*.jar/g' ${SERVICE}/conf/catalina.properties
if [ $? = 0 ];then
    echo -n "    "${HOSTNAME}--${HOSTIP}--${SERVICE}--"修改过滤jar包动作成功" && success
    echo ""
else
    echo -n "    "${HOSTNAME}--${HOSTIP}-${SERVICE}--"修改过滤jar包动作失败" && failure
    echo ""
fi
#rm ${TOMCAT_NAME} -rf
EOF
    ssh -p 14588 $HOSTIP < order.sh 2> /dev/null
done

