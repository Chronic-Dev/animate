//
//  
//  tableview
//
//  Created by Alex Mault (AlJaMa)  on 2/6/11.
//  Copyright 2011 Chronic-Dev. All rights reserved.
//

/* So why go with a PSViewController instead of a PSListController? It's because of the nature of this
 * pref bundle. We need to dynamicly decide what content is displayed based off of a directory listing.
 *
 */

#import <Preferences/PSViewController.h>

@interface BootLogoListController: PSViewController <UITableViewDelegate, UITableViewDataSource> {
    //an array of folders for possible boot logos.
    NSMutableArray *bootLogos;
    
    //the settings Dictionary
    NSMutableDictionary *plistDictionary;
    
    //The identifier of the currently selected logo.
    NSString *currentlySelected;
    
     //do I really need to explain this one?
    UITableView *_logoTable;
}

+ (void) load;

- (id) initForContentSize:(CGSize)size;
- (id) view;
- (id) navigationTitle;
- (void) themesChanged;

- (int) numberOfSectionsInTableView:(UITableView *)tableView;
- (id) tableView:(UITableView *)tableView titleForHeaderInSection:(int)section;
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(int)section;
- (id) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation BootLogoListController

//Our title... 
- (NSString*) title {
    return @"Boot Animation";
}

//just to be safe. Return the tableview if someone asks.
- (UIView*) view {
    return _logoTable;
}


+ (void) load {
    //every good party needs a pool!
    NSAutoreleasePool *pool([[NSAutoreleasePool alloc] init]);
    [pool release];
}

//The bulk of the initiation done here. 
- (id) initForContentSize:(CGSize)size {

    if ((self = [super init]) != nil) {
        bootLogos = [[NSMutableArray alloc] init];
        plistDictionary = [[NSMutableDictionary dictionaryWithContentsOfFile:@"/Library/BootLogos/bootlogo.plist"] retain];
        currentlySelected =  [plistDictionary objectForKey:@"logo"];
        if(currentlySelected == nil)
            currentlySelected = @"default";
        
        [self reloadPossibleLogos];
        
        _logoTable = [[UITableView alloc] initWithFrame: (CGRect){{0,0}, size} style:UITableViewStyleGrouped];
        [_logoTable setDataSource:self];
        [_logoTable setDelegate:self];
        if ([self respondsToSelector:@selector(setView:)])
            [self setView:_logoTable];

    }
    return self;
}

-(void)reloadPossibleLogos{
    id file = nil;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtPath:@"/Library/BootLogos/"];
    
    while ((file = [enumerator nextObject]))
    {
        BOOL isDirectory=NO;
        [[NSFileManager defaultManager]
         fileExistsAtPath:[NSString
                           stringWithFormat:@"%@/%@",@"/Library/BootLogos",file]
         isDirectory:&isDirectory];
        if (isDirectory && ![file isEqualToString:@"default"]){
            [bootLogos addObject:file];
        }
        
    }

}

-(void)view

//something changed, not sure what.. but lets reload the data anyways.
- (void) reloadSpecifiers{
[_logoTable reloadData];
}

//Headers are always a nice touch. 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"Built in";
    else
        return @"Extras";
}

- (void)viewWillAppear:(BOOL)animated{
    [self reloadPossibleLogos];
    [_logoTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - Table view data source

/*
 *All of this should be very self explanatory.. 
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    if([bootLogos count] > 0)
        return 2;
    else
        return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else
        return [bootLogos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"BLG: 2");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = @"Apple Logo";
            if([currentlySelected isEqualToString:@"apple"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Chronic Dev";
            if([currentlySelected isEqualToString:@"default"])
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }else if(indexPath.section ==1){
        cell.textLabel.text = [bootLogos objectAtIndex:indexPath.row];
        if([cell.textLabel.text isEqualToString:currentlySelected])
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [plistDictionary setObject:@"apple" forKey:@"logo"];
            currentlySelected = @"apple";
        }else if(indexPath.row == 1){
            [plistDictionary setObject:@"default" forKey:@"logo"];
            currentlySelected = @"default";
        }
    }else{
        [plistDictionary setObject:[bootLogos objectAtIndex:indexPath.row] forKey:@"logo"];
        currentlySelected = [bootLogos objectAtIndex:indexPath.row];
    }
    
    bool sucess= [plistDictionary writeToFile:@"/Library/BootLogos/bootlogo.plist" atomically:true];
    
    if(!sucess){
        UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"we were unable to save your changes. \n\n sorry.." delegate:nil cancelButtonTitle:@"darn!" otherButtonTitles:nil] autorelease];
        [errorAlert show];
    }
    [_logoTable reloadData];
    
}


@end

