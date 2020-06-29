% =================================================================================
%
% plot_latest_TS_profile    plots the latest T and S profiles
%                           contained in an Argo profile file.
%                           Uses some parameters read by the
%                           function argo_profile_read_matlab2008bplus.
%                            See reference:
%                         "Argo User's manual" available on
%                         http://www.argodatamgt.org/Documentation
%
% AUTHOR:                M. Scanderbeg
%
% REQUIRES:              Matlab2008b or higher which offers native NetCDF
%                        support
%
% EXAMPLE:               file_name='D5900400_014.nc';
%                        plot_latest_TS_profile                
%
% SEE ALSO:              argo_profile_read_matlab2008bplus.m      
% 
% file_name = '/levu/mcs/misc/argo_profile_matlab_reader/D5900400_014.nc'
% ================================================================================

[latitude,longitude,positioning_system,position_qc,juld_location,...
    juld,juldqc,pressure,pres_raw,pres_qc_raw,pres_qc,pressure_error,...
    pres_units, pres_fillvalue,temperature,temp_raw,temp_qc_raw,temp_qc,...
    temperature_error,temp_units,temp_fillvalue...
    salinity,psal_raw,psal_qc_raw,psal_qc,salinity_error,psal_units,psal_fillvalue...
    platform_number,cycle_number,data_type,format_version,project_name,...
    pi_name,direction,data_centre,data_state_indicator,data_mode,...
    dc_reference,platform_type,wmo_inst_type,station_parameters,...
    reference_date_time,vertical_sampling,config_mission_number]=...
    argo_profile_read_matlab2008bplus(file_name);

%PLOT


figure
subplot(1,2,1)
if ~isempty(temperature)
   plot(squeeze(temperature(:,end)),-squeeze(pressure(:,end)),'b')
  xlabel('temperature (deg.C)','Fontsize',8)
  ylabel('pressure (dcb)','Fontsize',8)
  grid on
  
end
subplot(1,2,2)
if ~isempty(salinity)
  plot(squeeze(salinity(:,end)),-squeeze(pressure(:,end)),'g')
  xlabel('salinity (psu)','Fontsize',8)
  ylabel('pressure (dcb)','Fontsize',8)
  grid on
end

set(gcf,'color',[1 1 1])

if (latitude(end)>=0)
  lat_str=[num2str(abs(latitude(end)),'%2.1f') 'N'];
else
  lat_str=[num2str(abs(latitude(end)),'%2.1f') 'S'];
end

if (longitude(end)>=0)
  lon_str=[num2str(abs(longitude(end)),'%2.1f') 'W'];
else 
  lon_str=[num2str(abs(longitude(end)),'%2.1f') 'E'];
end


suptitle(['Latest T and S profiles for platform ' ...
	  deblank(platform_number(end,:)) ' - cycle ' num2str(cycle_number(end)) ...
	  ' - ' datestr(juld(end),24) ...
	  ' - ' lat_str ', ' lon_str])
