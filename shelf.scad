shelfCount = 2;
shelfLength = 690;
depth = 170;
height = 430;
horizontalPillarSize = 35;
verticalPillarSize = 30;
topSpacing = 20;
materialThickness = 6;
stabilizerHeight = 60;
stabilizerFittingPieceWidth = 10;

kerf = 0.2;
fittingOffset = 0.02;
fittingPieceWidth = 20;
spaceBetweenObjects = 20;
holeRoundingRadius = 8;

shelfDepth = depth - materialThickness;

fittingHoleDepth = materialThickness - kerf + (fittingOffset * 2);
fittingHoleLength = fittingPieceWidth - (kerf * 2) + (fittingOffset * 2);
stabilizerFittingHoleDepth = materialThickness - kerf + (fittingOffset * 2);
stabilizerFittingHoleLength = stabilizerFittingPieceWidth - (kerf * 2) + (fittingOffset * 2);

module plotShelf() {
    
    layerHeight = (height - topSpacing) / shelfCount;
    echo("Shelf height(millimeters)", layerHeight);
    
    module plotSide() {
        module plotFittingHoles() {
            for (i = [1:shelfCount]) {
                y = ((height - topSpacing)/(shelfCount)) * i - (fittingHoleDepth/2);
                x1 = (shelfDepth/3) * 1 - (fittingHoleLength/2);
                x2 = (shelfDepth/3) * 2 - (fittingHoleLength/2);
                
                translate([x1, y]) {
                    square([fittingHoleLength, fittingHoleDepth]);
                }
                
                translate([x2, y]) {
                    square([fittingHoleLength, fittingHoleDepth]);
                }
            }
        }
        
        module plotStabilizerFittingHoles() {
            for (i = [1:shelfCount]) {
                x = depth - stabilizerFittingHoleDepth;
                y1 = ((height - topSpacing)/(shelfCount)) * i - (materialThickness/2) - (stabilizerHeight/3) * 1;;
                y2 = ((height - topSpacing)/(shelfCount)) * i - (materialThickness/2) - (stabilizerHeight/3) * 2;
                
                translate([x, y1]) {
                    square([stabilizerFittingHoleDepth, stabilizerFittingHoleLength]);
                }
                
                translate([x, y2]) {
                    square([stabilizerFittingHoleDepth, stabilizerFittingHoleLength]);
                }
            }
        }
        
        module plotShelfLevelHoles() {
            for (i = [0:shelfCount-1]) {
                y = i * layerHeight + (verticalPillarSize/2) + (holeRoundingRadius/2);
                
                holeWidth = depth - (horizontalPillarSize * 2) - (holeRoundingRadius * 2);
                holeHeight = layerHeight - verticalPillarSize - (holeRoundingRadius);
                
                translate([horizontalPillarSize + holeRoundingRadius, y]) {
                    minkowski() {
                        square([holeWidth, holeHeight]);
                        circle(r=holeRoundingRadius);
                    }
                }
            }
        }
        
        difference() {
            square([depth, height]);
            
            plotFittingHoles();
            plotStabilizerFittingHoles();
            plotShelfLevelHoles();
        }
    }
    
    module plotAllLayers() {
        for (i = [0:shelfCount-1]) {
            y = i * (depth + spaceBetweenObjects);
            translate([0, y]) {
                plotLayer();
            }
        }
    }
    
    module plotLayer() {
        module plotLayerFittingPieces() {
            y1 = (depth/3) * 1 - (fittingHoleLength/2);
            y2 = (depth/3) * 2 - (fittingHoleLength/2);
            
            translate([-fittingHoleDepth, y1]) {
                square([fittingHoleDepth, fittingHoleLength]);
            }
            
            translate([-fittingHoleDepth, y2]) {
                square([fittingHoleDepth, fittingHoleLength]);
            }
            
            translate([shelfLength, y1]) {
                square([fittingHoleDepth, fittingHoleLength]);
            }
            
            translate([shelfLength, y2]) {
                square([fittingHoleDepth, fittingHoleLength]);
            }
        }
        
        square([shelfLength, shelfDepth]);
        
        plotLayerFittingPieces();
    }
    
    module plotAllStabilizers() {
        for (i = [0:shelfCount-1]) {
            y = i * (stabilizerHeight + spaceBetweenObjects);
            translate([0, y]) {
                plotStabilizer();
            }
        }
    }
    
    module plotStabilizer() {
        module plotStabilizerFittingPieces() {
            y1 = (stabilizerHeight/3) * 1 - (stabilizerFittingHoleLength/2);
            y2 = (stabilizerHeight/3) * 2 - (stabilizerFittingHoleLength/2);
            
            translate([0, y1]) {
                square([stabilizerFittingHoleDepth, stabilizerFittingHoleLength]);
            }
            
            translate([0, y2]) {
                square([stabilizerFittingHoleDepth, stabilizerFittingHoleLength]);
            }
            
            translate([shelfLength + stabilizerFittingHoleDepth, y1]) {
                square([stabilizerFittingHoleDepth, stabilizerFittingHoleLength]);
            }
            
            translate([shelfLength + stabilizerFittingHoleDepth, y2]) {
                square([stabilizerFittingHoleDepth, stabilizerFittingHoleLength]);
            }
        }
        
        plotStabilizerFittingPieces();
        
        translate([stabilizerFittingHoleDepth, 0]) {
            square([shelfLength, stabilizerHeight]);
        }
    }
    
    plotSide();
    
    translate([depth + spaceBetweenObjects, 0]) {
        plotSide();
        
        translate([depth + spaceBetweenObjects, 0]) {
            plotAllLayers();
            
            translate([shelfLength + fittingHoleDepth * 2 + spaceBetweenObjects, 0]) {
                plotAllStabilizers();
            }
        }
    }
}

plotShelf();