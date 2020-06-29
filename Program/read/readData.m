function [Salt Temp Deep] = readData(filename,latmin,latmax,logmin,logmax)
load(filename);
Salt=salt(logmin:logmax,latmin:latmax,:);
Temp=temp(logmin:logmax,latmin:latmax,:);
Deep=pres;
end