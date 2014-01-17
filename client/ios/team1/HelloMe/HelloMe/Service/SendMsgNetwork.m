//
//  SendMsgNetwork.m
//  HelloMe
//
//  Created by 高丰 on 2013/12/21.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import "SendMsgNetwork.h"
#import "Message.h"
#import "MySingleton.h"

@implementation SendMsgNetwork
@synthesize delegate;

//封装soap请求,并向服务器发送请求
-(void)sendMsg:(Message *)msgInfo{
    NSString * strSendYear = msgInfo.receiveYear;
    NSString * strSendMonth = msgInfo.receiveMonth;
    NSString * strSendDay = msgInfo.receiveDay;
    NSString * strSendHour = msgInfo.receiveHour;
    NSString * strSendMinute = msgInfo.receiveMinute;
    //当前的系统时间 yyyyMMddHHmm
    NSString *newDateOne = [MySingleton getNowTime];
    NSString *strSendTime = @"";
    NSString *strReceiveTime = @"";
    strReceiveTime = [NSString stringWithFormat:@"%@%@%@%@%@",strSendYear,strSendMonth,strSendDay,strSendHour,strSendMinute];
    strSendTime=newDateOne;
    NSLog(@"接收时间为%@",strReceiveTime);

    NSLog(@"封装发送的soap请求消息");
    //封装soap请求消息
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<saveMail xmlns=\"http://impl.hellome.liandisys.com.cn/\">\n"
                             "<arg0 xmlns=\"\">%@</arg0>\n"
                             "<arg1 xmlns=\"\">%@</arg1>\n"
                             "<arg2 xmlns=\"\">%@</arg2>\n"
                             "<arg3 xmlns=\"\">%@</arg3>\n"
                             "<arg4 xmlns=\"\">%@</arg4>\n"
                             "<arg5 xmlns=\"\">%@</arg5>\n"
                             "<arg6 xmlns=\"\">%@</arg6>\n"
                             "</saveMail>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",strSendTime,strReceiveTime,msgInfo.userName,msgInfo.topic,msgInfo.text,msgInfo.sendImageName,msgInfo.sendImageString
                             ];
    NSLog(@"1111");
    NSLog(@"aaaaaaa%@",msgInfo.sendImageName);
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://172.16.53.180/HelloMe?wsdl"]];
    [request setTimeoutInterval:15.f];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue: @"http://impl.hellome.liandisys.com.cn/saveMail" forHTTPHeaderField:@"SOAPAction"];
    [request setHTTPBody:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	//如果连接已经建好，则初始化data
	if( theConnection )
	{
		_webData = [NSMutableData data];
	}
	else
	{
		NSLog(@"连接失败");
	}
}

//接收信息并解析,显示到用户界面
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[_webData setLength: 0];
	NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_webData appendData:data];
	NSLog(@"connection: didReceiveData:2");
    
}

//如果电脑没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"没有连接网络");
    [delegate linkServerAlert];
}

//存储接收到的信息
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *theXML = [[NSString alloc] initWithBytes: [_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"XML文件是：%@",theXML);
	_xmlParser = [[NSXMLParser alloc] initWithData: _webData];
	[_xmlParser setDelegate: self];
	[_xmlParser setShouldResolveExternalEntities: YES];
	[_xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"ns2:saveMailResponse"])
	{
		if(!_soapResults)
		{
			_soapResults = [[NSMutableString alloc] init];
		}
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"string:%@",string);
    [_soapResults appendString: string];
    NSLog(@"_soapResults是:%@",_soapResults);
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"elementName是:%@",elementName);
	if( [elementName isEqualToString:@"return"])
	{
        NSLog(@"_soapResults===%@",_soapResults);
        NSError *error;
        NSData *data=[_soapResults dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if ([[result valueForKey:@"status"] isEqualToString:@"success"]) {
            NSLog(@"发送成功");
        }else{
            NSLog(@"发送失败");
            [delegate sendFailure];
        }
	}
	
}

//解析调用
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"开始解析调用");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"结束解析调用");
}

@end
