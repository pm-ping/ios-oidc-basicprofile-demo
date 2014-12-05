//
//  UserInfoAppViewController.m
//  Copyright (c) 2013 Ping Identity. All rights reserved.
//

#import "UserInfoAppViewController.h"
#import "UserInfoAppCurrentSession.h"

@interface UserInfoAppViewController ()

@end

@implementation UserInfoAppViewController

NSTimer *sessionExpiry;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)configureView
{
    // We will display the users profile attributes if they are logged in:
    //  - given_name
    //  - family_name
    //  - email
    
    if ([[UserInfoAppCurrentSession session] inErrorState])
    {
        
    }
    else
    {
        if( [[UserInfoAppCurrentSession session] isAuthenticated])
        {
            NSString *email = [[UserInfoAppCurrentSession session] getValueForAttribute:@"email"];
            NSString *givenName = [[UserInfoAppCurrentSession session] getValueForAttribute:@"given_name"];
            NSString *familyName = [[UserInfoAppCurrentSession session] getValueForAttribute:@"family_name"];
            
            [self.outletEmail setText:email];
            [self.outletEmail setTextColor:[UIColor whiteColor]];
            [self.outletFirstName setText:givenName];
            [self.outletFirstName setTextColor:[UIColor whiteColor]];
            [self.outletLastName setText:familyName];
            [self.outletLastName setTextColor:[UIColor whiteColor]];
            [self.outletSignOutButton setEnabled:YES];
            
            sessionExpiry = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(sessionCountdown:) userInfo:nil repeats:YES];
            
        } else {
            
            [self.outletEmail setText:@"[not logged in]"];
            [self.outletEmail setTextColor:[UIColor lightGrayColor]];
            [self.outletFirstName setText:@"[not logged in]"];
            [self.outletFirstName setTextColor:[UIColor lightGrayColor]];
            [self.outletLastName setText:@"[not logged in]"];
            [self.outletLastName setTextColor:[UIColor lightGrayColor]];
            [self.outletSignOutButton setEnabled:NO];
            
            [self.outletSessionLifetime setText:@"[not logged in]"];
            [self.outletSessionLifetime setTextColor:[UIColor lightGrayColor]];
            [sessionExpiry invalidate];
        }
    }
    
}

- (void)configureViewDisplay
{
    // Handle the layout of the elements
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self configureViewDisplay];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (IBAction)actionSignInButton {
    
    // Here we redirect the user for authentication, we need some configuration information here though:
    //  - baseUrl / Issuer: The base URL for the authorization endpoint on the AS.  Will have /as/authorization.oauth2 appended.
    NSString *issuer = @"https://sso.meycloud.net:9031";
    [[UserInfoAppCurrentSession session] setIssuer:issuer];
    
    //  - response_type: token and/or id_token (we have a really basic use-case, authentication only, no API security)
    //  - scope: openid profile email (space delimited)
    NSString *scope = @"openid profile email";
    
    //  - client_id: the oauth2 client sampleapp_im_client
    NSString *clientId = @"sampleapp_basic_client";
    [[UserInfoAppCurrentSession session] setClientId:clientId];
    
    //  - redirect_uri: the endpoint to rturn the token - this is the app callback url com.pingidentity.OIDCUserInfoApp://oidc_callback
    NSString *redirectUri = @"com.pingidentity.OIDCUserInfoApp://oidc_callback";
    
    //  - here we could also define "idp" or "pfidpadapterid" to use a specific adapter or idp connection.
    NSString *pfidpadapterid = @"LDAP"; // My demo site has a number of IDP adapters mapped, so specify my LDAP adapter.
    
    OAuth2Client *basicProfile = [[OAuth2Client alloc] init];
    [basicProfile setBaseUrl:issuer];
    [basicProfile setAuthorizationEndpoint:@"/as/authorization.oauth2"];
    [basicProfile setOAuthRequestParameter:kOAuth2RequestParamClientId value:clientId];
    [basicProfile setOAuthRequestParameter:kOAuth2RequestParamRedirectUri value:redirectUri];
    [basicProfile setOAuthRequestParameter:kOAuth2RequestParamScope value:scope];
    [basicProfile setOAuthRequestParameter:kOAuth2RequestParamResponseType value:@"code"];
    [basicProfile setOAuthRequestParameter:kOAuth2RequestParamPfidpadapterid value:pfidpadapterid];
    
    [[UserInfoAppCurrentSession session] setOIDCBasicProfile:basicProfile];
    
    // Step 1 - Build the token url we need to redirect the user to
    NSString *authorizationUrl = [basicProfile buildAuthorizationRedirectUrl];
    NSLog(@"Calling authorization url: %@", authorizationUrl);
    
    // Step 2 - Redirect the user, the user will return in the SampleAppAppDelegate.m file
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authorizationUrl]];
    CFRunLoopRun();
    
    // We have returned from Safari and should have an authenticated user object
    if([[UserInfoAppCurrentSession session] inErrorState])
    {
        // Error - handle it
        NSString *errorText = [[[[UserInfoAppCurrentSession session] getLastError] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        NSLog(@"An error occurred: %@", errorText);
        [self.outletMessages setText:errorText];
        [self.outletMessages setTextColor:[UIColor redColor]];
    } else {
        // Then we call the UserInfo endpoint to get the attributes
        [[UserInfoAppCurrentSession session] createSessionFromIDToken:YES];
        NSLog(@"Session created");
    }
    
    [self.view setNeedsDisplay];
    [self configureView];
}

- (IBAction)actionSignOutButton {

    [[UserInfoAppCurrentSession session] logout];
    [self.view setNeedsDisplay];
    [self configureView];
}

- (IBAction)actionAbout {
    NSString *aboutText = @"This is an example of using the OpenID Connect Basic Client Profile to authenticate a user to a native iOS application.\n\nThis application will authenticate the user and retrieve attributes from the UserInfo endpoint.  The expiry of the id_token will be used as a session timeout.";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About"
                                                    message:aboutText
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)sessionCountdown:(NSTimer *)timer
{
    NSString *exp =[[UserInfoAppCurrentSession session] getValueForAttribute:@"exp"];
    
    if (exp != nil) {
        NSDate *expires = [NSDate dateWithTimeIntervalSince1970:[exp doubleValue]];
        NSTimeInterval interval = [expires timeIntervalSinceNow];
        
        if (interval < 0.0)
        {
            [self.outletSessionLifetime setText:@"Session Expired!"];
            [self.outletSessionLifetime setTextColor:[UIColor redColor]];
            [self.outletEmail setTextColor:[UIColor redColor]];
            [self.outletFirstName setTextColor:[UIColor redColor]];
            [self.outletLastName setTextColor:[UIColor redColor]];
            [timer invalidate];
        }
        else
        {
            NSString *sessionMessage = [NSString stringWithFormat:@"Expires in %.2f seconds", interval];
            [self.outletSessionLifetime setText:sessionMessage];
            [self.outletSessionLifetime setTextColor:[UIColor whiteColor]];
        }
    } else {
        [timer invalidate];
    }
}

@end
