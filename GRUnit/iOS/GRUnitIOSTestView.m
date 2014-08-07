//
//  GRUnitIOSTestView.m
//  GRUnit
//
//  Created by John Boiles on 8/8/11.
//  Copyright 2011. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "GRUnitIOSTestView.h"
#import <QuartzCore/QuartzCore.h>

@interface GRUnitIOSTestView ()
@property UILabel *textLabel;
@end

@implementation GRUnitIOSTestView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor whiteColor];

    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 100)];
    _textLabel.font = [UIFont systemFontOfSize:12];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.numberOfLines = 0;
    [self addSubview:_textLabel];

  }
  return self;
}

/*
 Real layout is not in layoutSubviews since scrollviews call layoutSubviews on every frame
 */
- (void)_layout {
  CGFloat y = 10;

  CGRect textLabelFrame = _textLabel.frame;
  textLabelFrame.size.height = [_textLabel.text sizeWithFont:_textLabel.font constrainedToSize:CGSizeMake(_textLabel.frame.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap].height;
  _textLabel.frame = textLabelFrame;

  CGRect textViewFrame = _textLabel.frame;
  textViewFrame.origin.y = y;
  _textLabel.frame = textViewFrame;
  
  self.contentSize = CGSizeMake(self.frame.size.width, textViewFrame.origin.y + textViewFrame.size.height + 10);
}

- (void)setText:(NSString *)text {
  _textLabel.text = text;
  [self _layout];
}

@end
