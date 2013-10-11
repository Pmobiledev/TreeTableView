
#import "TreeItem.h"

@implementation TreeItem

@synthesize base, path;
@synthesize numberOfSubitems;
@synthesize parentSelectingItem;
@synthesize ancestorSelectingItems;
@synthesize submersionLevel;
@synthesize isOpened;

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToSelectingItem:other];
}

- (BOOL)isEqualToSelectingItem:(TreeItem *)selectingItem {
	if (self == selectingItem)
        return YES;
	
	if ([base isEqualToString:selectingItem.base])
		if ([path isEqualToString:selectingItem.path])
			if (numberOfSubitems == selectingItem.numberOfSubitems)
				return YES;
	
	return NO;
}


@end
