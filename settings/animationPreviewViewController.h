/**
 * GreenPois0n Medicine - animate.mm
 * Copyright (C) 2011 Chronic-Dev Team
 * Copyright (C) 2011 Nicolas Haunold
 * Copyright (C) 2011 Justin Williams
 * Copyright (C) 2011 Alex Mault 
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/



#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>
#include <Preferences/PSViewController.h>

@interface animationPreviewViewController : PSViewController {
@private
    NSString *currentAnimation;
    NSMutableArray *imagesArr;
    CALayer *displayLayer;
    int currentFrame;
    NSTimer *animationTimer;
}
-(id)initWithAnimationName:(NSString*)animation;
@end
