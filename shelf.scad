shelfCount = 2;
shelfLength = 800;
depth = 200;
height = 400;
pillarSize = 20;
topSpacing = 20;
materialThickness = 6;

kerf = 0.2;
fittingOffset = 0.05;
fittingPieceWidth = 20;
spaceBetweenObjects = 20;

fittingHoleDepth = materialThickness + kerf + (fittingOffset * 2);
fittingHoleLength = fittingPieceWidth + (kerf * 2) + (fittingOffset * 2);

module plotShelf() {
    
    layerHeight = (height - topSpacing) / (shelfCount + 1);
    
    module plotSide() {
        module plotFittingHoles() {
            for (i = [1:shelfCount]) {
                y = ((height - topSpacing)/(shelfCount)) * i;
                x1 = (depth/3) * 1 - (fittingPieceWidth/2);
                x2 = (depth/3) * 2 - (fittingPieceWidth/2);
                
                translate([x1, y]) {
                    square([fittingHoleLength, fittingHoleDepth]);
                }
                
                translate([x2, y]) {
                    square([fittingHoleLength, fittingHoleDepth]);
                }
            }
        }
        
        difference() {
            square([depth, height]);
            
            plotFittingHoles();
        }
    }
    
    module plotAllLayers() {
        for (i = [0:shelfCount]) {
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
        
        square([shelfLength, depth]);
        
        plotLayerFittingPieces();
    }
    
    plotSide();
    
    translate([depth + spaceBetweenObjects, 0]) {
        plotSide();
        
        translate([depth + spaceBetweenObjects, 0]) {
            plotAllLayers();
        }
    }
}

plotShelf();