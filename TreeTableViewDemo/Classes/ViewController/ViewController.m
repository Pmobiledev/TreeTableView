
#import "ViewController.h"
#import "MainMenuItem.h"
#import "SectionMenuItem.h"
#import "SubMenuItem.h"

#define kRootPath @"/"

@interface ViewController ()
{
    NSMutableArray *_itemInfo;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedTreeItems = [NSMutableArray array];
	
	self.treeItems = [self listItemsAtPath:kRootPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)listItemsAtPath:(NSString *)path
{
    NSMutableArray *treeItemArray = [NSMutableArray array];
    
    for (SectionMenuItem *secMenuItem in self.itemInfo)
    {
        if ([path isEqualToString:kRootPath])
        {
            [treeItemArray addObject:[self treeItemWithBaseName:secMenuItem.name path:kRootPath subLevel:0 itemCount:[secMenuItem.mainMenuITemArray count]]];
        }
        else
        {
            for ( MainMenuItem *mainMenuItem in secMenuItem.mainMenuITemArray)
            {
                if ([path isEqualToString:[NSString stringWithFormat:@"/%@", secMenuItem.name]])
                {
                    [treeItemArray addObject:[self treeItemWithBaseName:mainMenuItem.name path:[NSString stringWithFormat:@"/%@", secMenuItem.name] subLevel:1 itemCount:[mainMenuItem.subMenuITemArray count]]];
                }
                else
                {
                    for ( SubMenuItem *subMenuItem in mainMenuItem.subMenuITemArray)
                    {
                        if ([path isEqualToString:[NSString stringWithFormat:@"/%@/%@", secMenuItem.name, mainMenuItem.name]])
                        {
                            [treeItemArray addObject:[self treeItemWithBaseName:subMenuItem.name path:[NSString stringWithFormat:@"/%@/%@", secMenuItem.name, mainMenuItem.name] subLevel:2 itemCount:0]];
                        }
                    }
                }
            }
        }
    }
    
    return treeItemArray;
}

- (TreeItem *)treeItemWithBaseName:(NSString*)baseName path:(NSString*)path subLevel:(int)level itemCount:(int)count
{
    TreeItem *treeITem,  *parentTreeItem;;
    treeITem = [[TreeItem alloc] init];
    [treeITem setBase:baseName];
    [treeITem setPath:path];
    [treeITem setSubmersionLevel:level];
    [treeITem setParentSelectingItem:parentTreeItem];
    [treeITem setAncestorSelectingItems:[NSMutableArray array]];
    [treeITem setNumberOfSubitems:count];
    
    return treeITem;
}

- (NSArray *)itemInfo
{
    if (_itemInfo == nil) {
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"ItemList" withExtension:@"plist"];
        NSArray *itemDictionariesArray = [[NSArray alloc ] initWithContentsOfURL:url];
        _itemInfo = [NSMutableArray arrayWithCapacity:[itemDictionariesArray count]];
        
        for (NSDictionary *itemDictionary in itemDictionariesArray)
        {
            SectionMenuItem *secItems = [[SectionMenuItem alloc] init];
            secItems.name = itemDictionary[@"name"];
            
            NSArray *mainMenuItemDictionaries = itemDictionary[@"mainMenuITemArray"];
            NSMutableArray *mainMenuItemArray = [NSMutableArray arrayWithCapacity:[mainMenuItemDictionaries count]];
            
            for (NSDictionary *mainMenuItemDictionary in mainMenuItemDictionaries)
            {
                MainMenuItem *mainMenuItem = [[MainMenuItem alloc] init];
                mainMenuItem.name = mainMenuItemDictionary[@"name"];

                NSArray *subMenuItemDictionaries = mainMenuItemDictionary[@"subMenuITemArray"];
                NSMutableArray *subMenuItemArray = [NSMutableArray arrayWithCapacity:[subMenuItemDictionaries count]];
                
                for (NSDictionary *subMenuItemDictionary in subMenuItemDictionaries)
                {
                    SubMenuItem *subMenuItem = [[SubMenuItem alloc] init];
                    [subMenuItem setValuesForKeysWithDictionary:subMenuItemDictionary];
                    
                    [subMenuItemArray addObject:subMenuItem];
                }
                mainMenuItem.subMenuITemArray = subMenuItemArray;
                
                [mainMenuItemArray addObject:mainMenuItem];
            }
            secItems.mainMenuITemArray = mainMenuItemArray;
            
            [_itemInfo addObject:secItems];
        }
    }
    
    return _itemInfo;
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.treeItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectingTableViewCell"];
	if (!cell)
		cell = [[TreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectingTableViewCell"];
	
	TreeItem *treeItem = [self.treeItems objectAtIndex:indexPath.row];
	
	cell.treeItem = treeItem;
	
    [cell.arrowButton setImage:[UIImage imageNamed:@"open_arrow.png"] forState:UIControlStateNormal];
	
	if ([treeItem numberOfSubitems])
    {
		[cell.countLabel setText:[NSString stringWithFormat:@"%d", [treeItem numberOfSubitems]]];
        [cell.arrowButton setHidden:NO];
    }
	else
    {
		[cell.countLabel setText:@"-"];
        [cell.arrowButton setHidden:YES];
	}
    
	[cell.titleLabel setText:[treeItem base]];
	[cell.titleLabel sizeToFit];
	
	[cell setDelegate:(id<TreeTableViewCellDelegate>)self];
    
	[cell setLevel:[treeItem submersionLevel]];
    
    return cell;
}

- (void)selectingItemsToDelete:(TreeItem *)selItems saveToArray:(NSMutableArray *)deleteSelectingItems
{
	for (TreeItem *obj in selItems.ancestorSelectingItems)
    {
		[self selectingItemsToDelete:obj saveToArray:deleteSelectingItems];
	}
	[deleteSelectingItems addObject:selItems];
}

- (NSMutableArray *)removeIndexPathForTreeItems:(NSMutableArray *)treeItemsToRemove
{
	NSMutableArray *result = [NSMutableArray array];
	
	for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i)
    {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
		TreeTableViewCell *cell = (TreeTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
		for (TreeItem *tmpTreeItem in treeItemsToRemove)
        {
			if ([cell.treeItem isEqualToSelectingItem:tmpTreeItem])
				[result addObject:indexPath];
		}
	}
	
	return result;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//On cell selection
}

#pragma mark - Actions

- (void)enlargeCollapse:(TreeTableViewCell *)cell WithTreeItem:(TreeItem *)cellTreeItem
{
    if(cellTreeItem.isOpened)
    {
        cellTreeItem.isOpened = FALSE;
        [cell.arrowButton setImage:[UIImage imageNamed:@"open_arrow.png"] forState:UIControlStateNormal];
    }
    else
    {
        cellTreeItem.isOpened = TRUE;
        [cell.arrowButton setImage:[UIImage imageNamed:@"close_arrow.png"] forState:UIControlStateNormal];
    }
	
	NSInteger insertTreeItemIndex = [self.treeItems indexOfObject:cell.treeItem];
	NSMutableArray *insertIndexPaths = [NSMutableArray array];
	NSMutableArray *insertselectingItems = [self listItemsAtPath:[cell.treeItem.path stringByAppendingPathComponent:cell.treeItem.base]];
	
	NSMutableArray *removeIndexPaths = [NSMutableArray array];
	NSMutableArray *treeItemsToRemove = [NSMutableArray array];
	
	for (TreeItem *tmpTreeItem in insertselectingItems)
    {
		[tmpTreeItem setPath:[cell.treeItem.path stringByAppendingPathComponent:cell.treeItem.base]];
		[tmpTreeItem setParentSelectingItem:cell.treeItem];
		
		[cell.treeItem.ancestorSelectingItems removeAllObjects];
		[cell.treeItem.ancestorSelectingItems addObjectsFromArray:insertselectingItems];
			
        insertTreeItemIndex++;
		
		BOOL contains = NO;
		
		for (TreeItem *tmp2TreeItem in self.treeItems)
        {
			if ([tmp2TreeItem isEqualToSelectingItem:tmpTreeItem])
            {
				contains = YES;
				
				[self selectingItemsToDelete:tmp2TreeItem saveToArray:treeItemsToRemove];
				
				removeIndexPaths = [self removeIndexPathForTreeItems:(NSMutableArray *)treeItemsToRemove];
			}
		}
		
		for (TreeItem *tmp2TreeItem in treeItemsToRemove)
        {
			[self.treeItems removeObject:tmp2TreeItem];
			
			for (TreeItem *tmp3TreeItem in self.selectedTreeItems)
            {
				if ([tmp3TreeItem isEqualToSelectingItem:tmp2TreeItem])
                {
					[self.selectedTreeItems removeObject:tmp2TreeItem];
					break;
				}
			}
		}
		
		if (!contains)
        {
			[tmpTreeItem setSubmersionLevel:tmpTreeItem.submersionLevel];
			
			[self.treeItems insertObject:tmpTreeItem atIndex:insertTreeItemIndex];
			
			NSIndexPath *indexPth = [NSIndexPath indexPathForRow:insertTreeItemIndex inSection:0];
			[insertIndexPaths addObject:indexPth];
		}
	}
	
	if ([insertIndexPaths count])
		[self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
	
	if ([removeIndexPaths count])
		[self.tableView deleteRowsAtIndexPaths:removeIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - TreeTableViewCellDelegate

- (void)treeTableViewCell:(TreeTableViewCell *)cell didTapIconWithTreeItem:(TreeItem *)cellTreeItem
{
	[self enlargeCollapse:cell WithTreeItem:cellTreeItem];
}

@end
