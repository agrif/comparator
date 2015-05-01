//
//  CMPInfoTableView.h
//  Comparator
//
//  Borrowed from OSU Bus.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

@class CMPInfoTableView;

@protocol CMPInfoTableViewDelegate
- (void) infoTableView: (CMPInfoTableView*) itv didSelectAction: (NSString*) action;
@end

@interface CMPInfoTableView : UITableView <UITableViewDataSource, UITableViewDelegate, NSXMLParserDelegate>
{
	__weak NSObject<CMPInfoTableViewDelegate>* infoTableViewDelegate;
	NSMutableArray* headers;
	NSMutableArray* sections;
	
	NSMutableDictionary* parse;
}

@property (nonatomic, weak) IBOutlet NSObject<CMPInfoTableViewDelegate>* infoTableViewDelegate;

- (BOOL) loadContentsOfURL: (NSURL*) url;

@end
