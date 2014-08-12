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
@property UITextView *textView;
@end

@implementation GRUnitIOSTestView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:13];
    _textView.textColor = [UIColor blackColor];
    [self addSubview:_textView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
   CGSize size = [_textView sizeThatFits:CGSizeMake(self.frame.size.width - 8, self.frame.size.height - 8)];
  _textView.frame = CGRectMake(8, 8, self.frame.size.width - 8, self.frame.size.height - 8);
  _textView.contentSize = size;
}

- (void)setText:(NSString *)text {
  _textView.text = text;
  [self setNeedsLayout];
  [self setNeedsDisplay];
}

@end
