//
//  UserInfoAppCurrentSession.h
//  Copyright (c) 2013 Ping Identity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth2Client.h"

@interface UserInfoAppCurrentSession : NSObject
{
    NSString *issuer;
    NSString *client_id;
    NSString *nonce;
    
    NSDictionary *_allAttributes;
}

@property (strong, nonatomic) OAuth2Client *OIDCBasicProfile;

+(UserInfoAppCurrentSession *)session;
-(void)logout;
-(NSArray *)getAllAttributes;
-(NSString *)getValueForAttribute:(NSString *)attribute;
-(BOOL)isAuthenticated;
-(BOOL)inErrorState;
-(void)createSessionFromIDToken:(BOOL)retrieveAttributesFromUserInfo;
-(NSString *)getLastError;
-(void)setIssuer:(NSString *)newIssuer;
-(void)setClientId:(NSString *)newClientId;

@end
