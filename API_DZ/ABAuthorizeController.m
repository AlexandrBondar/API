//
//  ABAuthorizeController.m
//  API_DZ
//
//  Created by Alexandr Bondar on 28.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import "ABAuthorizeController.h"

@interface ABAuthorizeController () <UIWebViewDelegate>

@property (strong, nonatomic) ABAccessToken* token;
@property (copy, nonatomic) ABLoginCompletionBlock completionBlock;
@property (strong, nonatomic) UIWebView* webView;

@end

@implementation ABAuthorizeController

- (instancetype)initWithCompletionBlock:(ABLoginCompletionBlock)completionBlock
{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:rect];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.navigationItem.title = @"LOGIN";

    [self.view addSubview:webView];
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=5673235&"
    "display=mobile&"
    "redirect"
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "scope=143382&"                                    // +2 +4 +16 + 131072  +8192 +4096  =143382
    "response_type=token&"
    "v=5.59&";
    
    self.webView = webView;
    self.webView.delegate = self;
    
    NSURL* URL = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:URL];
    [webView loadRequest:request];
    
    
}

- (void) dealloc {
    
    self.webView.delegate = nil;
}


#pragma mark - UIWebViewDelegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Response Authorization - %@", request);
    
    //http://hello.there/ #access_token=a761417e2d075c812c9480885df9aa894951467976886c352875264a51ab1538e5cb2890ded2bc676388a&expires_in=86400&user_id=10146189
    
    //из за использования другого редирект УРЛ - проверяем - входит ли в наш УРЛ (который мы хотим загружать) строка @"#access_token" и если входит, то делаем RETURN NO - т.е. не загружаем адрес в ВЕБ_ВЬЮ а просто парсим
    
    if ([[[request URL] description] rangeOfString:@"access_token"].location != NSNotFound) {
        
        ABAccessToken* token = [[ABAccessToken alloc] init];
        
        NSString* query = [[request URL] description]; //берём всю пришедшую строку
        
        NSArray* array = [query componentsSeparatedByString:@"#"]; // разбиваем её на две части разделённые #
        
        if ([array count] > 1) {
            
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* tokenValues = [pair componentsSeparatedByString:@"="];
            
            if ([tokenValues count] == 2) {
                
                NSString* key = [tokenValues firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [tokenValues lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    NSTimeInterval interval = [[tokenValues lastObject] doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                } else if ([key isEqualToString:@"user_id"]) {
                    token.userID = [tokenValues lastObject];
                }
                
            }
            
        }
        
        self.webView.delegate = nil;
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;

        
    }
    
    return YES;
}



@end
