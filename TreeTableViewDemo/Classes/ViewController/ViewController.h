
#import <UIKit/UIKit.h>
#import "TreeTableViewCell.h"
#import "TreeItem.h"

@interface ViewController : UITableViewController <TreeTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *treeItems;
@property (nonatomic, strong) NSMutableArray *selectedTreeItems;

@end
