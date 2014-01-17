//
//  RegistViewController.m
//  HellowMe
//
//  Created by 銭 宇傑 on 2013/12/18.
//  Copyright (c) 2013年 Smartphone18. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

@synthesize userName = _userName;
@synthesize password = _password;
@synthesize passwordAgain = _passwordAgain;

@synthesize registResult;
@synthesize recordResults;

@synthesize webData;
@synthesize soapResults;
@synthesize xmlParser;

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
    self.passwordAgain.secureTextEntry = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 登録情報を提出する
- (IBAction)submit:(id)sender {
    NSString *userName = [self.userName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *password = [self.password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *passwordAgain = [self.passwordAgain.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    // 情報の検証
    if (userName.length == 0) {
        UIAlertView *nameAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名不能为空!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [nameAlertView show];
        return;
    }
    else if (password.length == 0) {
        UIAlertView *passwordAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [passwordAlertView show];
        return;
    }
    else if ([password isEqualToString:passwordAgain] == NO) {
        UIAlertView *passwordAgainAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不一致!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [passwordAgainAlertView show];
        return;
    }
    else {
        recordResults = NO;
        registResult = NO;
        
        // 封装soap请求消息
        NSString *soapMessage = [NSString stringWithFormat:
                                 
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 
                                 "<soap:Body>\n"
                                 
                                 "<register xmlns=\"http://impl.hellome.liandisys.com.cn/\">\n"
                                 
                                 "<arg0 xmlns=\"\">%@</arg0>\n"
                                 
                                 "<arg1 xmlns=\"\">%@</arg1>"
                                 
                                 "</register>\n"
                                 
                                 "</soap:Body>\n"
                                 
                                 "</soap:Envelope>\n",userName,password
                                 
                                 ];
        
        // 请求
        NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
        
        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL
                                                                    URLWithString:@"http://172.16.53.180/HelloMe?wsdl"]];
        
        // 设置请求信息,第六句是soap信息。
        [theRequest setTimeoutInterval:15.f];
        
        [theRequest setValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [theRequest addValue: @"http://172.16.53.180/HelloMe/register" forHTTPHeaderField:@"SOAPAction"];
        
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        
        [theRequest setHTTPMethod:@"POST"];
        
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 请求连接
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

// 確認後、ログイン画面に戻る
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// リセット
- (IBAction)reset:(id)sender {
    self.userName.text = @"";
    self.password.text = @"";
    self.passwordAgain.text = @"";
}

// ログイン画面に戻る
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// returnのボタンをクリックして、ソフトキーボードを隠し
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

// 背景をクリックして、ソフトキーボードを隠し
- (IBAction)view_touchDown:(id)sender {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
    [self.passwordAgain resignFirstResponder];
    
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
    
}

// 存储接收到的信息
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 重新加載xmlParser
    
    xmlParser = [[NSXMLParser alloc] initWithData: webData];
    
    [xmlParser setDelegate: self];
    
    [xmlParser setShouldResolveExternalEntities: YES];
    
    [xmlParser parse];
    
    // 如果注册成功，则弹出提示框，点击确认按钮后返回登录界面
    if (registResult) {
        
        UIAlertView *submitAlertView = [[UIAlertView alloc] initWithTitle:@"注册成功！" message:@"恭喜您已注册成功，请点击确认按钮返回登录界面" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [submitAlertView show];
    }
}


// 解析结果
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
                                       namespaceURI:(NSString *) namespaceURI
                                      qualifiedName:(NSString *)qName
                                         attributes: (NSDictionary *)attributeDict
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
    
    if ([soapResults isEqualToString:@"{\"message\":\"注册成功！\",\"status\":\"success\"}"])
    {
        registResult = YES;
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
