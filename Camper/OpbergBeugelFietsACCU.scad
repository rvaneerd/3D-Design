$fn=50;

batteryWidth = 90;
batteryHeight = 70;
bottomSupportHeight = 2;
coverHeight = 26;
coverDepth = 6.5;
frameThickness=5;


module storageGap() {
minkowski() {
    intersection() {
        difference() {
            cube(size = [batteryWidth,batteryHeight,bottomSupportHeight]);
            color("blue",0.5) 
                    cube(size=[coverDepth, batteryHeight-coverHeight, bottomSupportHeight+1]);
            translate([(batteryWidth - coverDepth), 0, 0]) {
                color("blue",0.5) 
                    cube(size=[coverDepth, batteryHeight-coverHeight, bottomSupportHeight+1]);
            }
        }
        translate([batteryWidth / 2, -batteryHeight / 2+7.5, 0]) 
            color("green", 0.5)
                rotate([0,0,45])
                    cube(size = [batteryWidth,batteryWidth,bottomSupportHeight]);
        }
    cylinder(1, center=true);
}
}

module storageFrame() {
minkowski() {
    translate([-frameThickness / 2, -frameThickness / 2, 0])
        color("red", 0.5)
            cube([batteryWidth + frameThickness, batteryHeight + frameThickness, bottomSupportHeight]);
    cylinder(1, center=true);
}
}

difference() {
    storageFrame();
    storageGap();
}