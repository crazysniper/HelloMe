//
//  GetNewMailsNetwork.m
//  HelloMe
//
//  Created by Smartphone21 on 12/20/13.
//  Copyright (c) 2013 ldns. All rights reserved.
//

#import "GetNewMailsNetwork.h"
#import "EmailLogic.h"
#import "CommonDao.h"
@implementation GetNewMailsNetwork
@synthesize delegate;

- (void)getNewMails:(MailDTO *)dto
{
	//封装soap请求消息
	NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             "<getNewMails xmlns=\"http://impl.hellome.liandisys.com.cn/\">\n"
                             "<arg0 xmlns=\"\">%@</arg0>\n"
                             "<arg1 xmlns=\"\">%@</arg1>\n"
                             "</getNewMails>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",dto.userName,dto.sendTime
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
        NSLog(@"*******%@",(NSString*)_webData);
        
	}
	else
	{
		NSLog(@"theConnection is NULL");
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
    // RegiterResult = UserRegisterNetworkError;
	NSLog(@"ERROR with theConenction");
	
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"3 DONE. Received Bytes: %lu", (unsigned long)[_webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [_webData mutableBytes] length:[_webData length] encoding:NSUTF8StringEncoding];
	NSLog(@"%@",theXML);
	_xmlParser = [[NSXMLParser alloc] initWithData: _webData];
	[_xmlParser setDelegate: self];
	[_xmlParser setShouldResolveExternalEntities: YES];
	[_xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	NSLog(@"4 parser didStarElemen: namespaceURI: attributes:");
    
    if( [elementName isEqualToString:@"ns2:getNewMailsResponse"])
	{
        NSLog(@"***************registerRESPONSE");
		if(!_soapResults)
		{
			_soapResults = [[NSMutableString alloc] init];
		}
		
	}
	
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSLog(@"5 parser: foundCharacters:");
    
	
	
    [_soapResults appendString: string];
	
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	NSLog(@"6 parser: didEndElement:");
    
	if( [elementName isEqualToString:@"return"])
	{
        
        NSLog(@"===========%@",_soapResults);
		NSLog(@"register result");
        NSError *error;
        NSData *data=[_soapResults dataUsingEncoding:NSUTF8StringEncoding];
        result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
       // NSLog(@"==================%@",[result valueForKey:@"message"]);
        NSLog(@"==================%@",result);
//        NSArray *array = [result allValues];
        NSLog(@"%@",[result valueForKey:@"mails"]);
        
        NSArray *array = [result valueForKey:@"mails"];
        for (NSDictionary *dic in array) {
            MailDTO*dto=[[MailDTO alloc] init];
            dto.mailId=[[dic valueForKey:@"mainId"] intValue];
            dto.boxId=EMAILBOX_ID_SHOUJIAN;
            dto.userName=[dic valueForKey:@"userName"];
            dto.sendTime=[dic valueForKey:@"sendTime"];
            dto.receiveTime=[dic valueForKey:@"receiveTime"];
            dto.subject=[dic valueForKey:@"mailTitle"];
            dto.text=[dic valueForKey:@"mailContent"];
            dto.image=[dic valueForKey:@"imageBuffer"];
            dto.sendFileName=[dic valueForKey:@"imageName"];
            NSLog(@"%@",[dic valueForKey:@"mailContent"]);
            [EmailLogic addMailInfoTOLoaclDB:dto];
        }
        if ([[result valueForKey:@"status"] isEqualToString:@"failed"]) {
            [delegate getNewMailsFailed];
        }else
        {
        [delegate getNewMailsSuccessd];
        }
	}
	
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"-------------------start--------------");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"-------------------end--------------");
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
