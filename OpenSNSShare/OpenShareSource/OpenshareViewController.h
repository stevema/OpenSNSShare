//
//  OpenShareViewController.h
//  OpenSNSShare
//
//  Created by Steve on 11/7/12.
//
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface OpenShareViewController : UIViewController<UIActionSheetDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate>

@property(nonatomic,strong)UIViewController *rootViewController;
@property (nonatomic,strong) NSString *sharedTitle;
@property (nonatomic,strong) NSString *sharedText;
@property (nonatomic,strong) NSString *sharedURL;
//@property (nonatomic,strong) UIImage *sharedImage;
@property (nonatomic,strong) NSString *sharedImageURL;
@property(nonatomic,strong)NSString *app_key;
@property(nonatomic,strong)NSString *app_scrret;

@property(strong, nonatomic) SinaWeibo *weibo;

-(id)initWithRootViewController:(UIViewController *)rootViewController withAppKey:(NSString *)app_key appScrret:(NSString *)app_scrret;

-(void)showShareView;
@end
