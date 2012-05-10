library(Cairo);
CairoPNG(filename="${imgout:Graph.png}"); #, width=700, height=300)

# png(filename="${imgout:Graph.png}", type="cairo-png") #, width=700, height=300)

suppressMessages( library(ncdfFlow) );

suppressMessages( library(flowViz) );

xAxis <- labkey.url.params$xAxis;
yAxis <- labkey.url.params$yAxis;
listOfFilesNames <- labkey.url.params$filesNames;
rootPath <-labkey.url.params$path;

filesArray <- unlist(strsplit(listOfFilesNames, split=","));

fullPathToCDF <- paste(rootPath,"/fullCDF.cdf",sep="");

print("READING IN CDF FILE");
system.time(
suppressWarnings( flowSetToDisplay <- ncdfFlowSet_open( fullPathToCDF ) )
);
# flowSetToDisplay <- read.flowSet(files = filesArray, phenoData = list( Stim = 'Stim', SampleOrder = 'Sample Order', Replicate = 'Replicate' ) )

print("CONVERT TO FLOWSET");
system.time(
fs <- NcdfFlowSetToFlowSet( flowSetToDisplay[ filesArray ] )
);

if ( xAxis == "Time" ){
ptm <- proc.time()
	timeLinePlot( fs, yAxis);
} else if ( yAxis == "" ){
	argPlot <- as.formula( paste("~ `",xAxis,"`",sep="") ) 
ptm <- proc.time()
	densityplot( argPlot, fs );
} else {
	argPlot <- as.formula( paste("`",yAxis,"` ~  `",xAxis,"`",sep="") );
ptm <- proc.time()
	xyplot( argPlot, fs );
}

# ls.str()
print("PLOTTING");
proc.time() - ptm

dev.off();

