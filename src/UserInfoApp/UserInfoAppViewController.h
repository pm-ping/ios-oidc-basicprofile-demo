//
//  UserInfoAppViewController.h
//  Copyright (c) 2013 Ping Identity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoAppViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *outletSignInButton;
@property (weak, nonatomic) IBOutlet UIButton *outletSignOutButton;

@property (weak, nonatomic) IBOutlet UILabel *outletFirstName;
@property (weak, nonatomic) IBOutlet UILabel *outletLastName;
@property (weak, nonatomic) IBOutlet UILabel *outletEmail;
@property (weak, nonatomic) IBOutlet UILabel *outletSessionLifetime;

@property (weak, nonatomic) IBOutlet UILabel *outletMessages;


@end
