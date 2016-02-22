//
//  ViewController.m
//  点击Html中的图片
//
//  Created by qk365 on 16/2/22.
//  Copyright © 2016年 qk365. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = self;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cocoachina.com/programmer/20160113/14976.html"]]];
    
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *js = @"function addImageClickEvent() { \
                         var imgs = document.getElementsByTagName('img');\
                         for(var i = 0;i < imgs.length;i++) { \
                             var img = imgs[i];\
                             img.onclick = function () { \
                                window.location.href = 'hyb-image-preview:' + this.src;\
                             };\
                         }\
                   }";
    
    //注入JS代码
    [webView stringByEvaluatingJavaScriptFromString:js];
    //执行所注入的JS代码
    [webView stringByEvaluatingJavaScriptFromString:@"addImageClickEvent();"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme hasPrefix:@"hyb-image-preview"]) {
        //获取原始图片的完整URL
        NSString *src = [request.URL.absoluteString stringByReplacingOccurrencesOfString:@"hyb-image-preview:" withString:@""];
        if (src.length > 0 ) {
            //原始API展开图片
            //这里已经拿到所点击的图片的URL了
            //有时候会感觉点击无响应，这是因为webViewDidFinishLoad方法还没有调用
            //调用很晚的原因，通常是因为H5页面中有比较多的内容在加载
            //因此，若是原生App与H5要交互，H5要尽可能地提高加载速度
            //应用在执行的时候会先调用webViewDidFinishLoad方法
            NSLog(@"所点击的HTML中的img标签的图片的URL是:%@",src);
            
        }
    }

    return YES;
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
