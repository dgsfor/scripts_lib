#!/usr/local/bin/python  
# -*- coding:utf-8 -*- 

import os
from time import strftime,gmtime
from keys import keys

#get secret keys
AK = keys.AK
SK = keys.SK
server = keys.server
signature = keys.signature
path_style = keys.path_style
bucketName = keys.bucketName
objectType = keys.objectType

from com.obs.client.obs_client import ObsClient
# Constructs a obs client instance with your account for accessing OBS
obsClient = ObsClient(access_key_id=AK, secret_access_key=SK, server=server, signature=signature, path_style=path_style)

# the follow function is for upload a single/short file to OBS ,for big file such size bigger than 10Mb should follw multiuplod 
# a function for read file according to given filename
def readFile(fileName):
	file_object = open(fileName,'rb')
	try:
		all_content = file_object.read()
		return all_content
	finally:
		file_object.close()

# put a single file
def put_file(fileName):
	print "find file: " + fileName
	objectKey = objectType + '/' + os.path.basename(fileName)
	fileSize = str(os.path.getsize(fileName))
	resp = obsClient.putContent(bucketName, objectKey, readFile(fileName))
	if resp.status < 300:
	    print('Create object ' + objectKey + ' and upload successfully!\ntotally upload ' + fileSize + ' bytes\n')


#if the given filename is truely exists
local_time = strftime("%Y-%m-%d",gmtime())
detail_time = strftime("%Y-%m-%d %H:%M:%S")
logfile = open("/data/ldap_toHuaWeiYun/ldap_databk/logs/conf_upload.log",'a')
ldap_conf_backup_file_name = "/data/ldap_toHuaWeiYun/backup/%s-ldap-conf.tar.gz"%(local_time)
if os.path.exists(ldap_conf_backup_file_name):
	put_file(ldap_conf_backup_file_name)
	print >> logfile,"%s,upload %s,success"%(detail_time,ldap_conf_backup_file_name)
else:
	print >> logfile,"%s,upload %s,failure"%(detail_time,ldap_conf_backup_file_name)
