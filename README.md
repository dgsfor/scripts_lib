# scripts_lib
日常脚本库，包括python和shell等

- **1.get_ip_detail**
  
  依赖: python requests
  
  运行方式：python ip.py
  
  说明：得到ip地址的详细信息，通过淘宝的ip地址库接口进行查询，ip.txt里面是ip列表
  
  得到信息如下：
  
  ip:114.114.114.114
city:南京市
area_id:300000
region_id:320000
area:华东
city_id:320100
country:中国
region:江苏省
isp:
country_id:CN
county:
isp_id:-1
county_id:-1
- **2.auto_deploy_public_service**
  
  自动部署公共组件脚本
  
  组件包括zookeeper,codis,metaq,solr,nodejs
 
- **3.auto_modify_tomcat_conf**
  
  批量修改tomcat配置，包括以下：

  三个端口号，过滤jar包，字符集
