function [latmin,latmax,logmin,logmax]=tran(latMin,latMax,logMin,logMax,lat,log)
if lat =='S'
   latmin=-latMin;
   latmax=-latMax
   latmin=latmin+79.5+1;
   latmax=latmax+79.5+1;
elseif lat=='N'
   latmin=latMin+79.5+1;
   latmax=latMax+79.5+1;
end


if log == 'W'
    logmin=logMin-0.5+1;
    logmax=logMax-0.5+1
elseif log=='E'
    logmin=logMin+179.5+1;
    logmax=logMax+179.5+1;
end
end