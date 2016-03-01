//
//  ViewController.m
//  VPN
//
//  Created by zhubch on 1/11/16.
//  Copyright © 2016 zhubch. All rights reserved.
//

#import "ViewController.h"
#import <NetworkExtension/NetworkExtension.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createVPNProfile];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:NEVPNStatusDidChangeNotification object:nil];
}

- (void)createVPNProfile
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        
        if (error) {
            NSLog(@"Load config failed [%@]", error.localizedDescription);
            return;
        }
        
        if ([NEVPNManager sharedManager].protocolConfiguration) {
            // config exists
        }
        
        [self setupIPSec];
        [[NEVPNManager sharedManager] saveToPreferencesWithCompletionHandler:^(NSError *error) {
            NSLog(@"Save config failed [%@]", error.localizedDescription);
        }];
        
    }];
}

- (void)removeVPNProfile
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            [[NEVPNManager sharedManager] removeFromPreferencesWithCompletionHandler:^(NSError *error){
                if(error)
                {
                    NSLog(@"Remove error: %@", error);
                }
                else
                {
                    NSLog(@"removeFromPreferences");
                }
            }];
        }
    }];
    
}

- (void)setupIPSec
{
    // config IPSec protocol
    NEVPNProtocolIPSec *p = [[NEVPNProtocolIPSec alloc] init];
    p.username = @"i.vpno.net";
    p.serverAddress = @"45.79.92.249";

    // get password persistent reference from keychain
    NSString *password = @"i.vpno.net";
    NSData *paswordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    p.passwordReference = paswordData;
    
    // PSK
    p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
    NSString *secret = @"919QqO8F";
    NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
    p.sharedSecretReference = secretData;
    
    
    p.useExtendedAuthentication = NO;
    p.disconnectOnSleep = NO;
    
    [NEVPNManager sharedManager].protocolConfiguration = p;
    [NEVPNManager sharedManager].localizedDescription = @"VPN by zhubch";
}

- (void)connect
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            //配置IPSec
            [self setupIPSec];
            [[NEVPNManager sharedManager].connection startVPNTunnelAndReturnError:nil];
        }
    }];
}

- (void)disconnect
{
    [[NEVPNManager sharedManager] loadFromPreferencesWithCompletionHandler:^(NSError *error){
        if (!error)
        {
            [[NEVPNManager sharedManager].connection stopVPNTunnel];
        }
    }];
}

#pragma mark - VPN状态切换通知
- (void)VPNStatusDidChangeNotification
{
    switch ([NEVPNManager sharedManager].connection.status)
    {
        case NEVPNStatusInvalid:
        {
            NSLog(@"NEVPNStatusInvalid");
            break;
        }
        case NEVPNStatusDisconnected:
        {
            NSLog(@"NEVPNStatusDisconnected");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        case NEVPNStatusConnecting:
        {
            NSLog(@"NEVPNStatusConnecting");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        case NEVPNStatusConnected:
        {
            NSLog(@"NEVPNStatusConnected");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            break;
        }
        case NEVPNStatusReasserting:
        {
            NSLog(@"NEVPNStatusReasserting");
            break;
        }
        case NEVPNStatusDisconnecting:
        {
            NSLog(@"NEVPNStatusDisconnecting");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
