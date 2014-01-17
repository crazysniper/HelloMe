//
//  GetMsgNetwork.m
//  HelloMe
//
//  Created by 高丰 on 2013/12/21.
//  Copyright (c) 2013年 高丰. All rights reserved.
//

#import "GetMsgNetwork.h"
#import "Message.h"
#import "MySingleton.h"
#import "String.h"
#import "MessageService.h"

@implementation GetMsgNetwork

- (void)getMsg:(Message *)msgInfo{
    //当前的系统时间 yyyyMMddHHmm
    NSString *newDateOne = [MySingleton getNowTime];
    NSString *currentTime = @"";
    currentTime=newDateOne;
    NSLog(@"收件箱的用户名%@",msgInfo.userName);
    
    //封装封装收件箱的soap请求消息
    NSLog(@"封装收件箱的soap请求消息");
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getNewMails xmlns=\"http://impl.hellome.liandisys.com.cn/\">\n"
                             "<arg0 xmlns=\"\">%@</arg0>\n"
                             "<arg1 xmlns=\"\">%@</arg1>\n"
                             "</getNewMails>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",msgInfo.userName,currentTime
                             ];
	NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://172.16.53.180/HelloMe?wsdl"]];
    [request setTimeoutInterval:15.f];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request addValue: @"http://impl.hellome.liandisys.com.cn/getNewMails" forHTTPHeaderField:@"SOAPAction"];
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
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"3 DONE. Received Bytes: %lu", (unsigned long)[_webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"XML是：%@",theXML);
	_xmlParser = [[NSXMLParser alloc] initWithData: _webData];
	[_xmlParser setDelegate: self];
	[_xmlParser setShouldResolveExternalEntities: YES];
	[_xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"ns2:getNewMailsResponse"])
	{
		if(!_soapResults)
		{
			_soapResults = [[NSMutableString alloc] init];
		}
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   [_soapResults appendString: string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"return"])
	{
        NSError *error;
        NSData *data=[_soapResults dataUsingEncoding:NSUTF8StringEncoding];
        _result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"1111111%@",[_result valueForKey:@"mails"]);
        
        NSString *sendYear=@"";
        NSString *sendMonth=@"";
        NSString *sendDay=@"";
        NSString *sendHour=@"";
        NSString *sendMinute=@"";
        NSString *receiveYear=@"";
        NSString *receiveMonth=@"";
        NSString *receiveDay=@"";
        NSString *receiveHour=@"";
        NSString *receiveMinute=@"";
        NSArray *array = [_result valueForKey:@"mails"];
        
        MessageService *manageServivce=[[MessageService alloc]init];
        for (NSDictionary *dic in array) {
            Message *msg=[[Message alloc] init];
           
            msg.messageID=[dic valueForKey:@"mailId"];
           
            //截取发送时间的年月日时分
            NSString *sendTime=[dic valueForKey:@"sendTime"];
            NSRange rang1 = NSMakeRange(0, 4);
            NSRange rang2 = NSMakeRange(4, 2);
            NSRange rang3 = NSMakeRange(6, 2);
            NSRange rang4 = NSMakeRange(8, 2);
            NSRange rang5 = NSMakeRange(10, 2);
            sendYear=[sendTime substringWithRange:rang1];
            sendMonth=[sendTime substringWithRange:rang2];
            sendDay=[sendTime substringWithRange:rang3];
            sendHour=[sendTime substringWithRange:rang4];
            sendMinute=[sendTime substringWithRange:rang5];
            msg.sendYear=sendYear;
            msg.sendMonth=sendMonth;
            msg.sendDay=sendDay;
            msg.sendHour=sendHour;
            msg.sendMinute=sendMinute;

            //截取接收时间的年月日时分
            NSString *receiveTime=[dic valueForKey:@"receiveTime"];
            receiveYear=[receiveTime substringWithRange:rang1];
            receiveMonth=[receiveTime substringWithRange:rang2];
            receiveDay=[receiveTime substringWithRange:rang3];
            receiveHour=[receiveTime substringWithRange:rang4];
            receiveMinute=[receiveTime substringWithRange:rang5];
            msg.receiveYear=receiveYear;
            msg.receiveMonth=receiveMonth;
            msg.receiveDay=receiveDay;
            msg.receiveHour=receiveHour;
            msg.receiveMinute=receiveMinute;
            NSLog(@"%@",msg.receiveYear);
            NSLog(@"%@",msg.receiveMonth);
            NSLog(@"%@",msg.receiveDay);
            NSLog(@"%@",msg.receiveHour);
            NSLog(@"%@",msg.receiveMinute);
            
            
            msg.userName=[dic valueForKey:@"userName"];
            msg.topic=[dic valueForKey:@"mailTitle"];
            msg.text=[dic valueForKey:@"mailContent"];
            msg.boxID=sReceiveDivision;
            msg.sendImageName=[dic valueForKey:@"imageName"];
            msg.sendImageString=[dic valueForKey:@"imageBuffer"];
            NSLog(@"%@",msg.sendImageString);
            NSLog(@"%@",msg.sendImageName);
            
            //插入到本地数据库
           [manageServivce insertMessageInfo:msg];
            NSLog(@"222222%@",[dic valueForKey:@"mailContent"]);
        }
        
	}
	
}

//解析XML
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"开始解析调用");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"结束解析调用");
}

@end
