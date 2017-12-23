#!/usr/bin/env python
# coding: utf8
#
import requests
file = open("./ip.txt")
while 1:
	lines = file.readlines(100000)
	if not lines:
		break
	for line in lines:
		#print line
		r = requests.get("http://ip.taobao.com/service/getIpInfo.php?ip=%s"%(line))
		data = r.json()["data"]
		for k,v in data.iteritems():
			print("%s:%s"%(k,v))
file.close()
