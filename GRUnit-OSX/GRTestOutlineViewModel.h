//
//  GRTestOutlineViewModel.h
//  GRUnit
//
//  Created by Gabriel Handford on 7/17/09.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GRTestViewModel.h"
@class GRTestOutlineViewModel;

#define MIN_WINDOW_WIDTH (635.0)

@protocol GRTestOutlineViewModelDelegate <NSObject>
- (void)testOutlineViewModelDidChangeSelection:(GRTestOutlineViewModel *)testOutlineViewModel;
@end



@interface GRTestOutlineViewModel : GRTestViewModel 
#if MAC_OS_X_VERSION_MAX_ALLOWED >= 1060 // on lines like this to not confuse IB
  <NSOutlineViewDelegate, NSOutlineViewDataSource> 	
#endif
{	
  __unsafe_unretained id<GRTestOutlineViewModelDelegate> delegate_;
	NSButtonCell *editCell_;
}

@property (unsafe_unretained, nonatomic) id<GRTestOutlineViewModelDelegate> delegate;

@end
