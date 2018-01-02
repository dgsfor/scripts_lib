#!/usr/local/bin/python  
# -*- coding:utf-8 -*- 
#author :zhoulongbo
#date: 2017-11-04

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
local_time = strftime("%Y-%b-%-d",gmtime())
detail_time = strftime("%Y-%m-%d %H:%M:%S")
gitlab_allfileName = '/data/gitlab/backup/data_all_%s.tar.aes'%(local_time)
gitlab_difffileName = '/data/gitlab/backup/data_diff_%s.tar.aes'%(local_time)

logfile = open("/data/gitlab_toHuaWeiYun/gitlab_databk/logs/data_upload.log",'a')
if os.path.exists(gitlab_allfileName):
	put_file(gitlab_allfileName)
	print >> logfile,"%s,upload %s,success"%(detail_time,gitlab_allfileName)
elif os.path.exists(gitlab_difffileName):
	put_file(gitlab_allfileName)
	print >> logfile,"%s,upload %s,success"%(detail_time,gitlab_difffileName)
else:
	print >> logfile,"%s,upload failure"%(detail_time)
