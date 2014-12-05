//
//  Peer.m
//  MobileAssassin
//
//  Created by Harleen Kaur on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import "Peer.h"

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
    _peer = [[MCPeerID alloc] initWithDisplayName:displayName];
    
    _session = [[MCSession alloc] initWithPeer:_peer];
    _session.delegate = self;
}

-(void)setupMCBrowser{
    _browser = [[MCBrowserViewController alloc] initWithServiceType:@"chat-files" session:_session];
}

-(void)advertiseSelfInNetwork:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
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
