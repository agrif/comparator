//
//  CMPInsetLabel.m
//  Comparator
//
//  Borrowed from OSU Bus.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//
//  this source is originally from
//  http://stackoverflow.com/a/17557490
//  though it has been modified
//

#import "CMPInsetLabel.h"

@implementation CMPInsetLabel

- (id) initWithFrame: (CGRect) frame {
	self = [super initWithFrame: frame];
	if (self)
	{
		self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
	}
	return self;
}

- (void) drawTextInRect: (CGRect) rect {
	[super drawTextInRect: UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize) sizeThatFits: (CGSize) size
{
	CGSize maximumSize = CGSizeMake(size.width - (self.edgeInsets.left + self.edgeInsets.right), FLT_MAX);
	CGSize result = [self.text sizeWithFont: self.font constrainedToSize: maximumSize lineBreakMode: self.lineBreakMode];
	
	result.width = size.width;
	result.height += self.edgeInsets.top + self.edgeInsets.bottom;
	result.height = ceilf(result.height);
	return result;
}

- (CGSize) intrinsicContentSize
{
	return [self sizeThatFits: self.frame.size];
}

@end