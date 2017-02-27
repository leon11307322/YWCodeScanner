//
//  ViewController.m
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "ViewController.h"
#import "YWCodeFactory.h"

@interface ViewController ()<YWCodeScannerProtocol>
{
    YWCodeFactory *_factory;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //1-创建简单的工厂
    _factory = [[YWCodeFactory alloc]init];
    
    // 1.1-设置codeView的frame
   id<YWCodeScannerProtocol>codeTool = [_factory getCodeView:CGRectMake(([UIScreen mainScreen].bounds.size.width - 280) /2.0, 100, 280, 280)];
     // 1.2-设置lineView的frame
    id<YWCodeScannerProtocol>lineTool = [_factory getCodeLineView:CGRectMake(0, 0, 280, 2)];
    
    //2-获取codeview的view [codeTool getCodeView]，并添加的self.view
    
    [self.view addSubview:[codeTool getCodeView]];
    
    //3-获取lineView的view [codeTool getCodeLineView]，并且添加到codeView
    
    [[codeTool getCodeView] addSubview:[lineTool getCodeView]];
    
////  方法一：  使用代理获取扫描值
//    _factory.delegate = self;
    
//    设置扫描完成后的铃声
    _factory.video = @"sound.caf";
//    开始扫描
    [_factory startQRCode:self.view];
    
//    方法二：block回调
    __weak typeof(self) weakSelf = self;

    _factory.returnCodeBlock = ^(NSString * code){
        
       [weakSelf dismissViewControllerAnimated:YES completion:nil];
        
    };
    
}
//方法一
//- (void)didmissViewValue:(NSString *)value{
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}




@end
