//
//  LobbyInfo.h
//  MobileAssassin
//
//  Created by Swetha RK on 12/4/14.
//  Copyright (c) 2014 Enrique Jose Padilla. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LobbyInfo : NSObject

@property (nonatomic, copy) NSString *lobbyName;
@property (nonatomic, assign) int minNumOfPlayers;
@property (nonatomic, assign) int maxNumOfPlayers;
@property (nonatomic, assign) Boolean isFull;

@end
