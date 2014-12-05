//
//  Peer.m
//  MobileAssassin
//
//  Created by Harleen Kaur on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "Peer.h"
#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "AssasinateViewController.h"

@implementation Peer

-(id)init{
    self = [super init];
    
    if (self) {
        _session = nil;
        _peer = nil;
        _advertiseAssistant = nil;
        _browser = nil;
    }
    
    return self;
}


-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    //need to set player name here as well
    _peer = [[MCPeerID alloc] initWithDisplayName:displayName];
    _session = [[MCSession alloc] initWithPeer:_peer];
    _session.delegate = self;
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info {
    
    NSLog(@"Session Manager found peer: %@", peerID);

    //dismissing the middle view controller/searching for other devices
    [_browser dismissViewControllerAnimated:YES completion:nil];

    AssasinateViewController *assasinateViewController = [[AssasinateViewController alloc] initWithNibName:@"AssasinateViewController" bundle:nil];
    assasinateViewController.toBeAssasinatedPlayer = [NSString stringWithString:peerID.displayName];
    //setting the value to local variable
}


-(void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-files" session:_session];
    
    
    _nearbyServiceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_peer serviceType:@"chat-files"];
    _nearbyServiceBrowser.delegate = self;
    
    [_serviceAdvertiser startAdvertisingPeer];
    [_nearbyServiceBrowser startBrowsingForPeers];
     
}

-(void)advertiseSelfInNetwork:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        _serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_peer discoveryInfo:nil serviceType:@"chat-files"];
        _serviceAdvertiser.delegate = self;

        
        _advertiseAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:@"chat-files"
                                                                   discoveryInfo:nil
                                                                         session:_session];
        [_advertiseAssistant start];
    }
    else{
        [_advertiseAssistant stop];
        _advertiseAssistant = nil;
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler {
    
    NSLog(@"invitation received");
    
}



// Peer lost, ex. out of range
- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"Session Manager lost peer: %@", peerID);
    
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error {
    NSLog(@"Did not start browsing for peers: %@", error);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    NSLog(@"Did not start advertising error: %@", error);
}


-(void)session:(MCSession *)session peer:(MCPeerID *)peer didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peer": peer,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peer{
    NSDictionary *dict = @{@"data": data,
                           @"peer": peer
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:dict];
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peer withProgress:(NSProgress *)progress{
    
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peer atURL:(NSURL *)localURL withError:(NSError *)error{
    
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peer{
    
}

@end
