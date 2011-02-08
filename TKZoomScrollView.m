

#import "TKZoomScrollView.h"

@implementation TKZoomScrollView

@synthesize toShowLarge;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.maximumZoomScale = 4.5;
    self.minimumZoomScale = 1;
    self.clipsToBounds = YES;
        
    return self;
}

- (void)setFrame:(CGRect)rect {
    [super setFrame:rect];
  
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touched ended");
    NSSet *allTouches = [event allTouches];	
	switch ([allTouches count]) 
	{
		case 1: //Single touch
		{ 
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];			
			switch ([touch tapCount])
			{
				case 1: //Single Tap.
				{
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"showOrHideItemViewControls" object:nil];
                }break;
					
				case 2: //Double tap.
				{}break;
			}
		}break;
            
		case 2: //Double Touch
		{
            
        }break;
			
		default:
			break;
	}	
}

-(void)setContentOffset:(CGPoint)p
{   
    CGSize viewSize = self.contentSize;
    if(viewSize.width > 0 && viewSize.height > 0)
    {
        CGSize	scrollSize = self.bounds.size;

        if(viewSize.width < scrollSize.width)
        {
            p.x = -(scrollSize.width - viewSize.width) / 2.0;
        }

        if(viewSize.height < scrollSize.height)
        {
            p.y = -(scrollSize.height - viewSize.height) / 2.0;
        }

        [super setContentOffset:p];
    }
}

- (void)dealloc
{
	[super dealloc];
}


@end
