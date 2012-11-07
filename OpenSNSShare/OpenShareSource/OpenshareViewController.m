//
//  OpenShareViewController.m
//  OpenSNSShare
//
//  Created by Steve on 11/7/12.
//
//

#import "OpenShareViewController.h"

@interface OpenShareViewController ()

@end

@implementation OpenShareViewController

@synthesize app_key = _app_key;
@synthesize app_scrret = _app_scrret;
@synthesize rootViewController = _rootViewController;
@synthesize sharedTitle = _sharedTitle;
@synthesize sharedText = _sharedText;
@synthesize sharedImageURL = _sharedImageURL;
@synthesize sharedURL = _sharedURL;

@synthesize weibo = _weibo;

-(id)initWithRootViewController:(UIViewController *)rootViewController withAppKey:(NSString *)app_key appScrret:(NSString *)app_scrret;
{
    self = [super init];
    _rootViewController = rootViewController;
    _app_key = app_key;
    _app_scrret = app_scrret;
    
    _weibo = [[SinaWeibo alloc] initWithAppKey:APP_KEY appSecret:APP_SCRRET appRedirectURI:@"http://weibo.com/chunlinpage" andDelegate:self];
    return self;
}

-(void)showShareView
{
    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博", nil];
    [alert showInView:_rootViewController.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view=[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view.backgroundColor=[UIColor clearColor];
}

-(void)shareToSNS
{
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    NSString *url = nil;
    NSDictionary *authData = [[NSUserDefaults standardUserDefaults] objectForKey:@"authData"];
    [data setObject:[authData valueForKey:@"accessToken"] forKey:@"access_token"];
    [data setObject:_sharedText forKey:@"status"];
    if (_sharedImageURL) {
        [data setObject:_sharedImageURL forKey:@"url"];
        url = @"statuses/upload_url_text.json";
        
    }else {
        url = @"statuses/update.json";
    }
    [_weibo requestWithURL:url params:data httpMethod:@"POST" delegate:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"ok");
    NSDictionary *authData = [[NSUserDefaults standardUserDefaults] objectForKey:@"authData"];
    
    NSLog(@"access token is :%@",[authData valueForKey:@"accessToken"]);
    
    if ([authData valueForKey:@"accessToken"] == nil ) {
        [_weibo logIn];
    }else {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [format setTimeZone:gmt];
        [format setDateFormat:@"yy-MM-dd HH:mm:ss Z"];
        NSLog(@"auth exp date is :%@",[authData valueForKey:@"expDate"]);
        NSDate *date = [format dateFromString:[NSString stringWithFormat:@"%@",[authData valueForKey:@"expDate"]]];
        NSTimeInterval timeInt = [date timeIntervalSince1970];
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        if (now > timeInt) {
            [_weibo logIn];
        }else {
            [self shareToSNS];
        }
        
    }
    
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return [_weibo handleOpenURL:url];
//}
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return [_weibo handleOpenURL:url];
//}

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    [self storeAuthData];
}

- (void)storeAuthData
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              _weibo.accessToken, @"accessToken",
                              _weibo.expirationDate, @"expDate",
                              _weibo.userID, @"userID",
                              _weibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"authData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [self shareToSNS];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
