#ios-oidc-basicprofile-demo

### Overview

Demo iPhone application that uses the OpenID Connect Basic profile to authenticate a user to a native iOS application and call the UserInfo endpoint to retrieve profile information about the user.


### Author

Paul Meyer (pmeyer@pingidentity.com)


### System Requirements / Dependencies

Requires:
 - PingFederate 7.2.x or higher
 - My OpenID Connect library

 
### Installation
 
Import into Xcode and run on an iPhone device.


### Configuration

The application is configured to my test environment. Change the configuration values in the UserInfopAppViewController.m file (actionSignInButton method) to point to your PingFederate instance (or other OP).

