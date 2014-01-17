//
//  LoginViewController.m
//  HellowMe
//
//  Created by 銭 宇傑 on 2013/12/17.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SendMessageViewControl.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loginResult;
@synthesize recordResults;

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;

@synthesize userName = _userName;
@synthesize password = _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // パスワードのボックスを設定する
	self.password.secureTextEntry = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSString *userName = [self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //　ユーザー名とパスワードは空にできません
    if (userName.length == 0) {
        UIAlertView *nameAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [nameAlertView show];
        return;
    }
    else if (password.length == 0) {
        UIAlertView *passwordAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [passwordAlertView show];
        return;
    }
    
    else {
        //        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sendMessage"]
        //                           animated:YES completion:nil];
        
        // 登录时将用户名和密码保存在AppDelegate中，以便以后使用
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.kUserName = self.userName.text;
        delegate.kPassword = self.password.text;
        
        // 初始化变量
        recordResults = NO;
        loginResult = NO;
        
        // 封装soap请求消息
        NSString *soapMessage = [NSString stringWithFormat:
                                 
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 
                                 "<soap:Body>\n"
                                 
                                 "<login xmlns=\"http://impl.hellome.liandisys.com.cn/\">\n"
                                 
                                 "<arg0 xmlns=\"\">%@</arg0>\n"
                                 
                                 "<arg1 xmlns=\"\">%@</arg1>"
                                 
                                 "</login>\n"
                                 
                                 "</soap:Body>\n"
                                 
                                 "</soap:Envelope>\n",userName,password
                                 ];
        
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:
                                                                                   @"http://172.16.53.180/HelloMe?wsdl"]];
        
        // 设置请求信息,第六句是soap信息。
        [theRequest setTimeoutInterval:5];
        
        [theRequest setValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [theRequest addValue: @"http://172.16.53.180/HelloMe/login" forHTTPHeaderField:@"SOAPAction"];
        
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        
        [theRequest setHTTPMethod:@"POST"];
        
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        //请求连接
        NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        //如果连接已经建好，则初始化data
        if( theConnection )
        {
            webData = [[NSMutableData data] init];
        } else {
            UIAlertView *connectionAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"连接服务器失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [connectionAlertView show];
        }
    }
}

// リセット
- (IBAction)reset:(id)sender {
    self.userName.text = @"";
    self.password.text = @"";
}

- (IBAction)regist:(id)sender {
    // 登録のページへ遷移する
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"regist"] animated:YES completion:nil];
}

- (IBAction)view_touchDown:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



// 下面是接收信息并解析
// 接收信息
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}


//如果电脑没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *connectAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的电脑没有连接网络" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [connectAlertView show];
    
    //    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sendMessage"]
    //                                animated:YES completion:nil];
    [self performSegueWithIdentifier:@"sendMessage" sender:self];
}

// 存储接收到的信息
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 重新加載xmlParser
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    
    [xmlParser setDelegate: self];
    
    [xmlParser setShouldResolveExternalEntities: YES];
    
    [xmlParser parse];
    
    // 如果登录成功，则跳转到写信页面
    if (loginResult) {
        
        //        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"sendMessage"]
        //                           animated:YES completion:nil];
        [self performSegueWithIdentifier:@"sendMessage" sender:self];
        
    } else {
        
        UIAlertView *failAlertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"用户名和密码错误！"
                                                               delegate:self cancelButtonTitle:@"确认"
                                                      otherButtonTitles:nil, nil];
        
        [failAlertView show];
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //goToInbox
    if ([segue.identifier isEqualToString:@"templetter"]) {
        SendMessageViewControl *messagedetail =(SendMessageViewControl *)segue.destinationViewController;
        messagedetail.isFromTemp = @"NO";
    }
    
}

// 解析结果
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI
qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"return"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = YES;
    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(recordResults)
    {
        [soapResults appendString: string];
    }
    
    if ([soapResults isEqualToString:@"{\"message\":\"登录成功！\",\"status\":\"success\"}"])
    {
        loginResult = YES;
    }
}


// 显示接收的信息
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName

{
    if( [elementName isEqualToString:@"return"])
        
    {
        recordResults = FALSE;
        soapResults = nil;
    }
}


@end
