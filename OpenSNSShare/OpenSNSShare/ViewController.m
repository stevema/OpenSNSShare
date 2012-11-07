//
//  ViewController.m
//  OpenSNSShare
//
//  Created by Steve on 11/7/12.
//
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize openShareViewController = _openShareViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _openShareViewController = [[OpenShareViewController alloc] initWithRootViewController:self withAppKey:APP_KEY appScrret:APP_SCRRET];
    self.view.frame=[UIScreen mainScreen].applicationFrame;
    [self.view addSubview:_openShareViewController.view];
    _openShareViewController.sharedText = @"我在写一个微博分享组件哦";
    [_openShareViewController showShareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
