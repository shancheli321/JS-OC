//
//  FourWeChatSnowViewController.m
//  JS_OC
//
//  Created by shancheli on 16/1/15.
//  Copyright © 2016年 Halley. All rights reserved.
//

#import "FourWeChatSnowViewController.h"

#define IMAGENAMED(NAME)        [UIImage imageNamed:NAME]
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define IMAGE_X                arc4random()%(int)Main_Screen_Width
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 20
#define PLUS_HEIGHT            Main_Screen_Height/25

@interface FourWeChatSnowViewController ()<UIWebViewDelegate>
{
    NSMutableArray *_imagesArray;
}
@property (strong, nonatomic) IBOutlet UIWebView *web;

@end

@implementation FourWeChatSnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _web.scrollView.bounces=NO;
    _web.delegate=self;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_web loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    _imagesArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 12; ++ i) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coin.png"]];
        imageView.frame = CGRectMake(IMAGE_X, -40, 40, 40);
        [_web addSubview:imageView];
        [_imagesArray addObject:imageView];
    }
    
    
}
- (IBAction)openPacket:(UIButton *)sender {
    
    [_web stringByEvaluatingJavaScriptFromString:@"mytoast('H5 弹出框')"];
}
static int i = 0;
- (void)makeSnow
{
    i = i + 1;
    if ([_imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        imageView.tag = i;
        [_imagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }
    
}
- (void)snowFall:(UIImageView *)aImageView
{
    [UIView beginAnimations:[NSString stringWithFormat:@"%li",(long)aImageView.tag] context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, Main_Screen_Height, aImageView.frame.size.width, aImageView.frame.size.height);
    [UIView commitAnimations];
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
    float x = IMAGE_WIDTH;
    imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
    [_imagesArray addObject:imageView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if([request.URL.absoluteString hasSuffix:@"window.nativeapi.nativeaction()"]) {
        
        [NSTimer scheduledTimerWithTimeInterval:.3 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
        
        return NO;
    }
    
    
    return YES;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
    
}

@end
