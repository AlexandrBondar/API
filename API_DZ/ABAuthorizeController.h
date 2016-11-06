//
//  ABAuthorizeController.h
//  API_DZ
//
//  Created by Alexandr Bondar on 28.10.16.
//  Copyright © 2016 Alexandr Bondar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABAccessToken.h"
#import "ABServerManager.h"

typedef void(^ABLoginCompletionBlock)(ABAccessToken* token);

@interface ABAuthorizeController : UIViewController

- (instancetype)initWithCompletionBlock:(ABLoginCompletionBlock)completionBlock;


@end
