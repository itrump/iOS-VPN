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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VPNStatusDidChangeNotification) name:NEVPNStatusDidChangeNotification object:nil];
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
