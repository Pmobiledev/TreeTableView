
#import <UIKit/UIKit.h>

@class TreeTableViewCell;
@class TreeItem;

@protocol TreeTableViewCellDelegate  <NSObject>
- (void)treeTableViewCell:(TreeTableViewCell *)cell didTapIconWithTreeItem:(TreeItem *)treeItem;
@end

@interface TreeTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton  *arrowButton;
@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UILabel   *countLabel;
@property (nonatomic, assign) id <TreeTableViewCellDelegate> delegate;
@property (nonatomic, strong) TreeItem *treeItem;
@property (nonatomic, assign) BOOL isOpened;

- (void)setLevel:(NSInteger)pixels;

@end
