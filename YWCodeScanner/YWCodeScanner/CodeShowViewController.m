//
//  CodeShowViewController.m
//  YWCodeScanner
//
//  Created by yw on 2017/2/27.
//  Copyright © 2017年 yw. All rights reserved.
//

#import "CodeShowViewController.h"
#import "YWCodeImageFactory.h"

@interface CodeShowViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImage1;

@property (weak, nonatomic) IBOutlet UIImageView *codeImage2;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage3;


/** 工具*/
@property (nonatomic, strong) YWCodeImageFactory *factory;


@end

@implementation CodeShowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _factory = [YWCodeImageFactory new];
//    标清
//    _codeImage1.image = [_factory getCodeDefalutData:@"https://github.com/flyOfYW/YWCodeScanner.git"];
    
//    高清
    _codeImage1.image = [_factory getCodeHightDefalut:@"https://github.com/flyOfYW/YWCodeScanner.git" withImageSize:120.f];
    
    _codeImage2.image = [_factory getCodeWithLogo:@"pic_portrait_small" withParam:@"https://github.com/flyOfYW/YWCodeScanner.git" withSamllLogoScale:0.3];
    
    _codeImage3.image = [_factory getCodeWithtData:@"https://github.com/flyOfYW/YWCodeScanner.git" backgroundColor:[CIColor whiteColor] mainColor:[CIColor redColor]];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
