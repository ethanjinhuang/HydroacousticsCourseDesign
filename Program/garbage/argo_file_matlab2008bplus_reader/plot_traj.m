% =================================================================================
%
% plot_traj             plots the trajectory of the Argo float.
%                           Uses some parameters read by the
%                           function argo_trajv3p1_read_matlab2008bplusm or
%                           function argo_trajv2_read_matlab2008bplus.m.  
%                           Choose which function to use based on the file
%                           format of the trajectory file.
%                            See reference:
%                         "Argo User's manual" available on
%                         http://www.argodatamgt.org/Documentation
%
% AUTHOR:                M. Scanderbeg
%
% REQUIRES:              Matlab2008b or higher which offers native NetCDF
%                        support
%
% EXAMPLE:               file_name='5900400_traj.nc';
%                        plot_traj              
%
% SEE ALSO:              argo_trajv3p1_read_matlab2008bplus.m      
% 
% ncfil = '5900400_traj.nc'
% ncfil = '1900728_traj.nc'
% ================================================================================

% if the trajectory file is v3.1, use this function to get the data

%  [m_len,c_len,qc,juld_qc,PI_name,xlat,xlon,jday,...
%                       sday,grnd,pac,pressure,temp,jae,jas,jds,jde,...
%                       jaes,jass,jdss,jdes,jdst,jdsts,no_pts,...
%                       plat,transmis_sys,cycles,nlat,dmode]=...
%                        argo_trajv3p1_read_matlab2008bplus(ncfil);

                   
% if the trajectory file is v2.3, use this function to get the data

  [m_len,c_len,qc,juld_qc,PI_name,xlat,xlon,jday,...
                      grnd,pac,thepres,thetemp,thepsal,...
                      jae,jas,jds,jde,...
                      jaes,jass,jdss,jdes,jdst,jdsts,...
                      plat,transmis_sys,cycles,nlat,dmode]=...
                       argo_trajv2_read_matlab2008bplus(ncfil);


%PLOT


figure
hold on

for r=1:c_len
    yplot=find(xlat(1:nlat(r),r)~=0);
    plot(xlon(yplot,r),xlat(yplot,r),'-bo')
end

name=strcat('Argo float trajectory for float WMO ID#',ncfil(1:7));
title(name)
      xlabel('degrees longitude')
      ylabel('degrees latitude')