//
//  Peer.h
//  MobileAssassin
//
//  Created by Harleen Kaur on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface Peer : NSObject

@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiseAssistant;
@property (nonatomic, strong) MCPeerID *peer;

@property (nonatomic, strong) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *nearbyServiceBrowser;

//@property (weak, nonatomic) IBOutlet NSString *toBeAssasinatedPlayer;


-(void)advertiseSelfInNetwork:(BOOL)shouldAdvertise;
-(void)setupMCBrowser;
-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
@end
