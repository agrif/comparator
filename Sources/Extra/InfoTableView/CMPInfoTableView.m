//
//  CMPInfoTableView.m
//  Comparator
//
//  Borrowed from OSU Bus.
//  Copyright (c) 2015 Aaron Griffith. Licensed under the Apache License v2.0.
//  See COPYING or https://www.apache.org/licenses/LICENSE-2.0
//

#import "CMPInfoTableView.h"
#import "CMPInsetLabel.h"

@implementation CMPInfoTableView

@synthesize infoTableViewDelegate;

- (instancetype) initWithFrame: (CGRect) frame
{
	self = [super initWithFrame: frame];
	if (self)
		[self clearInfo: YES];
	
	return self;
}

- (instancetype) initWithCoder: (NSCoder*) aDecoder
{
	self = [super initWithCoder: aDecoder];
	if (self)
		[self clearInfo: YES];
	
	return self;
}

- (void) clearInfo: (BOOL) rebuild
{
    headers = nil;
    sections = nil;
	
	if (rebuild)
	{
		headers = [[NSMutableArray alloc] initWithCapacity: 10];
		sections = [[NSMutableArray alloc] initWithCapacity: 10];
		
		self.dataSource = self;
		self.delegate = self;
	}
}

- (void) dealloc
{
	[self clearInfo: NO];
    parse = nil;
}

#pragma mark data add helpers

- (void) addText: (NSString*) text
{
	[sections addObject: [NSMutableArray arrayWithCapacity: 3]];
	
	CMPInsetLabel* label = [[CMPInsetLabel alloc] init];
	label.text = text;
	label.numberOfLines = 0;
	label.textAlignment = NSTextAlignmentLeft;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	label.edgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
	
	[headers addObject: label];
}

- (void) addLink: (NSString*) link withAction: (NSString*) action
{
	if (sections.count == 0)
		[self addText: @""];
	
	NSMutableArray* section = [sections objectAtIndex: sections.count - 1];
	[section addObject: [NSDictionary dictionaryWithObjectsAndKeys: link, @"text", action, @"action", nil]];
}

#pragma mark loading xml, and xml delegate stuff

- (BOOL) loadContentsOfURL: (NSURL*) url
{
	NSXMLParser* parser = [[NSXMLParser alloc] initWithContentsOfURL: url];
	if (!parser)
	{
		NSLog(@"parsing %@ failed, could not create parser\n", url);
		return NO;
	}
	
	parser.delegate = self;
	BOOL result = [parser parse];
	if (!result)
	{
		NSLog(@"parsing %@ failed, %@\n", url, parser.parserError);
	}
	
	return result;
}

- (void) parserDidStartDocument: (NSXMLParser*) parser
{
	[self clearInfo: YES];
    parse = nil;
}

- (void) parserDidEndDocument: (NSXMLParser*) parser
{
	parse = nil;
	[self reloadData];
}

- (void) parser: (NSXMLParser*) parser didStartElement: (NSString*) elementName namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qName attributes: (NSDictionary*) attributeDict
{
	if (parse)
		return;
	
	if ([elementName isEqual: @"text"])
	{
		parse = [[NSMutableDictionary alloc] initWithCapacity: 2];
		[parse setValue: @"text" forKey: @"element"];
		[parse setValue: [NSMutableString string] forKey: @"text"];
	} else if ([elementName isEqual: @"link"]) {
		parse = [[NSMutableDictionary alloc] initWithCapacity: 3];
		[parse setValue: @"link" forKey: @"element"];
		[parse setValue: [attributeDict objectForKey: @"action"] forKey: @"action"];
		[parse setValue: [NSMutableString string] forKey: @"text"];
	}
}

- (void) parser: (NSXMLParser*) parser foundCharacters: (NSString*) string
{
	if (!parse)
		return;
	
	NSMutableString* text = [parse objectForKey: @"text"];
	if (text)
		[text appendString: string];
}

- (void) parser: (NSXMLParser*) parser didEndElement: (NSString*) elementName namespaceURI: (NSString*) namespaceURI qualifiedName: (NSString*) qName
{
	if (!parse)
		return;
	
	NSString* element = [parse objectForKey: @"element"];
	if ([element isEqual: @"text"])
	{
		[self addText: [parse objectForKey: @"text"]];
	} else if ([element isEqual: @"link"]) {
		[self addLink: [parse objectForKey: @"text"] withAction: [parse objectForKey: @"action"]];
	}
	
	parse = nil;
}

#pragma mark table view delegate and data source

- (NSInteger) numberOfSectionsInTableView: (UITableView*) tableView
{
	return sections.count;
}

- (NSInteger) tableView: (UITableView*) tableView numberOfRowsInSection: (NSInteger) section
{
	return [[sections objectAtIndex: section] count];
}

- (UITableViewCell*) tableView: (UITableView*) lTableView cellForRowAtIndexPath: (NSIndexPath*)indexPath
{
	UITableViewCell* cell = [lTableView dequeueReusableCellWithIdentifier: @"UITableViewCell"];
	if (!cell)
	{
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"UITableViewCell"];
	}
	
	[cell setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
	
	NSArray* section = [sections objectAtIndex: [indexPath indexAtPosition: 0]];
	NSDictionary* link = [section objectAtIndex: [indexPath indexAtPosition: 1]];
	[cell.textLabel setText: [link objectForKey: @"text"]];
	
	return cell;
}

- (UIView*) tableView: (UITableView*) lTableView viewForHeaderInSection: (NSInteger) section
{
	UIView* view = [headers objectAtIndex: section];
	
	CGRect frame = view.frame;
	frame.size.width = lTableView.frame.size.width;
	view.frame = frame;
	[view sizeToFit];
	
	return view;
}

- (CGFloat)tableView: (UITableView*) lTableView heightForHeaderInSection: (NSInteger) section
{
	UIView* view = [self tableView: lTableView viewForHeaderInSection: section];
	NSUInteger height = view.frame.size.height;
	
	return height;
}

- (void) tableView: (UITableView*) lTableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath
{
	NSArray* section = [sections objectAtIndex: [indexPath indexAtPosition: 0]];
	NSDictionary* link = [section objectAtIndex: [indexPath indexAtPosition: 1]];
	if (infoTableViewDelegate)
		[infoTableViewDelegate infoTableView: self didSelectAction: [link objectForKey: @"action"]];
}

@end
