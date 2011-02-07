#import <Preferences/PSViewController.h>
//#import "PrefsView.h"
@interface BootLogoListController: PSViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *bootLogos;
    NSMutableDictionary *plistDictionary;
    NSString *currentlySelected;
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


- (NSString*) title {
    return @"Boot Animation";
}

- (UIView*) view {
    return _logoTable;
}
+ (void) load {
    NSAutoreleasePool *pool([[NSAutoreleasePool alloc] init]);
    
    NSLog(@"load has been called");
    [pool release];
}
- (id) initForContentSize:(CGSize)size {
     NSLog(@"init content size called");
    if ((self = [super init]) != nil) {
        bootLogos = [[NSMutableArray alloc] init];
        plistDictionary = [[NSMutableDictionary dictionaryWithContentsOfFile:@"/Library/BootLogos/bootlogo.plist"] retain];
        currentlySelected =  [plistDictionary objectForKey:@"logo"];
        if(currentlySelected == nil)
            currentlySelected = @"default";
        
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
        
        _logoTable = [[UITableView alloc] initWithFrame: (CGRect){{0,0}, size} style:UITableViewStyleGrouped];
        [_logoTable setDataSource:self];
        [_logoTable setDelegate:self];
       // [_logoTable setEditing:YES];
       // [_logoTable setAllowsSelectionDuringEditing:YES];
        if ([self respondsToSelector:@selector(setView:)])
            [self setView:_logoTable];

    }
     NSLog(@"init content size returning");
    return self;
}
- (void) reloadSpecifiers{
[_logoTable reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return @"Built in";
    else
        return @"Extras";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


#pragma mark - Table view data source

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
    
    // [plistDictionary writeToFile:@"/Users/Alex/bootlogos/bootlogo.plist" atomically:true encoding:NSUTF8StringEncoding error:&error];
    bool sucess= [plistDictionary writeToFile:@"/Library/BootLogos/bootlogo.plist" atomically:true];
    
    if(!sucess){
        UIAlertView *errorAlert = [[[UIAlertView alloc] initWithTitle:@"Error" message:@"we were unable to save your changes. \n\n sorry.." delegate:nil cancelButtonTitle:@"darn!" otherButtonTitles:nil] autorelease];
        [errorAlert show];
    }
    [_logoTable reloadData];
    
}


@end

