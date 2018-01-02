#!/usr/bin/python
# -*- coding:utf-8 -*-


# 引入模块
from com.obs.client.obs_client import ObsClient

# 创建ObsClient实例
obsClient = ObsClient(
    access_key_id='UDSIAMSTUBTEST000100',    
    secret_access_key='Udsiamstubtest000000UDSIAMSTUBTEST000100',    
    server='obs.esdk.com',
    path_style=True,
    signature='v2',
    long_conn_mode=False,
    is_secure=False # 配置使用HTTPS协议
)

# 引入模块
from com.obs.client.obs_client import ObsClient

# 创建ObsClient实例
obsClient = ObsClient(
    access_key_id='*** Provide your Access Key ***',    
    secret_access_key='*** Provide your Secret Key ***',    
    server='obs.myhwclouds.com'
)

obsClient.abortMultipartUpload('bucketname', 'objectkey', 'upload id from initiateMultipartUpload')

if resp.status < 300:
    print('requestId:', resp.requestId)
else:    
    print('status:', resp.status)    


# from com.obs.models.put_object_header import PutObjectHeader
# headers = PutObjectHeader()
# resp1 = obsClient.getObject('bucket005', 'test')
#      
# headers.contentLength = dict(resp1.header)['content-length']
#      
# resp = obsClient.putContent('bucket008', 'test_python', resp1.body.response, headers=headers)
# print('common msg:status:', resp.status, ',errorCode:', resp.errorCode, ',errorMessage:', resp.errorMessage)
#     
# resp1.body.response.close()

# 关闭obsClient
obsClient.close()
