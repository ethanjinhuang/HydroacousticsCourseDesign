% =================================================================================
%
% argo_trajv3p1_read_matlab2008bplus
%                         reads some of the variables contained in an
%                         Argo NetCDF trajectory file. See
%                         reference:
%                         "Argo User's manual" available on
%                         http://www.argodatamgt.org/Documentation
%
% AUTHOR:                M. Scanderbeg
%
% REQUIRES:              Matlab2008b or higher which offers native NetCDF
%                        support
%            
%
% EXAMPLE:               ncfil='5900400_Dtraj.nc';
%
%
%                       [m_len,c_len,qc,juld_qc,PI_name,xlat,xlon,jday,...
%                       sday,grnd,pac,pressure,temp,jae,jas,jds,jde,...
%                       jaes,jass,jdss,jdes,jdst,jdsts,no_pts,...
%                       plat,transmis_sys,cycles,nlat,dmode]=...
%                        argo_trajv3p1_read_matlab2008bplus(ncfil);
%
%                  
%
%  FURTHER INFORMATION:
%
% All surface locations and their time, qc, and status flags are read in 
% and then put in matrices with one column for every
% cycle regardless of whether or not that cycle has data.  Zeros are the
% fill value for no numerical data for these arrays and space is fill value
% for the string variables
%
% Cycle timing variables are not in arrays, but in column vectors.  One row
% for each cycle.  Fill value is 999999
%
% ncfil is the filename of the traj.nc file you want to open
% 
% NOTE:  Measurement codes for the surface period (ie from 700 through
% 800) will be in ascending numerical order for Argos floats, but NOT for 
% Iridium floats.  This is because JULD must be in chronological order and 
% the locations (code 703) come before the start of transmission because 
% they are from the GPS fix and not from the Iridium satellite. 


% % % %%%%%%%%%%%%%%%%%%%%%%%%
% ncfil='5900400_traj.nc'



% ================================================================================
% % 
  function[m_len,c_len,qc,juld_qc,PI_name,xlat,xlon,jday,...
                      sday,grnd,pac,pressure,temp,jae,jas,jds,jde,...
                      jaes,jass,jdss,jdes,jdst,jdsts,no_pts,...
                      plat,transmis_sys,cycles,nlat,dmode]=...
                       argo_trajv3p1_read_matlab2008bplus(ncfil);

 no_pts=[];    
   sday=[];         
   pqt=[];          
   grnd=' ';        clear cpac
clf



for xx=1:1

       fidh= netcdf.open(ncfil, 'nowrite');  % Open NetCDF file
       
       % get dimensions and PI name, platform, etc.
       
   thevar=netcdf.inqVarID(fidh,'PI_NAME');
   PI_name=netcdf.getVar(fidh,thevar);
   
   thedim=netcdf.inqDimID(fidh,'N_MEASUREMENT');
   [dimname,m_len] = netcdf.inqDim(fidh,thedim);
   thedim=netcdf.inqDimID(fidh,'N_CYCLE');
   [dimname, cy_len] = netcdf.inqDim(fidh,thedim);
   thevar=netcdf.inqVarID(fidh,'CYCLE_NUMBER');   
   cnum=netcdf.getVar(fidh,thevar);
   cnum=double(cnum);
  thevar=netcdf.inqVarID(fidh,'CYCLE_NUMBER_ADJUSTED');   
   cnum_adj=netcdf.getVar(fidh,thevar);
   thevar=netcdf.inqVarID(fidh,'PLATFORM_TYPE');   
   plat=netcdf.getVar(fidh,thevar)
     thevar=netcdf.inqVarID(fidh,'POSITIONING_SYSTEM');   
   transmis_sys=netcdf.getVar(fidh,thevar)

   
   % first get the N_MEASUREMENT variables
   
      thevar=netcdf.inqVarID(fidh,'MEASUREMENT_CODE');   
   mcode=netcdf.getVar(fidh,thevar);
  
        thevar=netcdf.inqVarID(fidh,'LATITUDE'); 
        lat=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'LONGITUDE');
       lon=netcdf.getVar(fidh,thevar);       
       thevar=netcdf.inqVarID(fidh,'POSITION_ACCURACY');
       ipac=netcdf.getVar(fidh,thevar);
       pacm=ipac';       
       thevar=netcdf.inqVarID(fidh,'POSITION_QC');
       qc=netcdf.getVar(fidh,thevar);
       
       thevar=netcdf.inqVarID(fidh,'JULD');
       juld=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_STATUS');
       julds=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_QC');
       juld_qc=netcdf.getVar(fidh,thevar);
       
       thevar=netcdf.inqVarID(fidh,'JULD_ADJUSTED');
       juld_adj=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_ADJUSTED_STATUS');
       julds_adj=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_ADJUSTED_QC');
       if isempty(thevar)==0
       juld_adj_qc=netcdf.getVar(fidh,thevar);
       end
       thevar=netcdf.inqVarID(fidh,'PRES');
       presm=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PRES_QC');
       presm_qc=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PRES_ADJUSTED');
       presm_adj=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PRES_ADJUSTED_ERROR');
       presm_adj_error=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PRES_ADJUSTED_QC');
       presm_adj_qc=netcdf.getVar(fidh,thevar);
         
       thevar=netcdf.inqVarID(fidh,'TEMP');                     
       tempm=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'TEMP_QC');                     
       tempm_qc=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'TEMP_ADJUSTED');
       tempm_adj=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'TEMP_ADJUSTED_ERROR');
       tempm_adj_error=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'TEMP_ADJUSTED_QC');
       tempm_adj_qc=netcdf.getVar(fidh,thevar);
                    
       thevar=netcdf.inqVarID(fidh,'PSAL');
       psalm=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PSAL_QC');
       psalm_qc=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PSAL_ADJUSTED');
       psalm_adj=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PSAL_ADJUSTED_ERROR');
       psalm_adj_error=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'PSAL_ADJUSTED_QC');
       psalm_adj_qc=netcdf.getVar(fidh,thevar);             
       
       


%    %        % now get all the N_CYCLE variables
       thevar=netcdf.inqVarID(fidh,'CYCLE_NUMBER_INDEX');   
       cnum_ind=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'CYCLE_NUMBER_INDEX_ADJUSTED');   
       cnum_ind_adj=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_ASCENT_END');
       ajae=netcdf.getVar(fidh,thevar);
      % ajae(2);
       thevar=netcdf.inqVarID(fidh,'JULD_ASCENT_END_STATUS');
       ajaes=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_ASCENT_START');
       ajas=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_ASCENT_START_STATUS');
       ajass=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DESCENT_START');
       ajds=netcdf.getVar(fidh,thevar);
       %ajds(2);
       thevar=netcdf.inqVarID(fidh,'JULD_DESCENT_START_STATUS');
       ajdss=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DESCENT_END');
       ajde=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DESCENT_END_STATUS');
       ajdes=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_TRANSMISSION_START');
       ajdst=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_TRANSMISSION_START_STATUS');
       ajdsts=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_TRANSMISSION_END');
       ajte=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_TRANSMISSION_END_STATUS');
       ajtes=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_FIRST_STABILIZATION');
       ajfs=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_FIRST_STABILIZATION_STATUS');
       ajfss=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_PARK_START');
       ajps=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_PARK_START_STATUS');
       ajpss=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_PARK_END');
       ajpe=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_PARK_END_STATUS');
       ajpes=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DEEP_PARK_START');
       ajdps=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DEEP_PARK_START_STATUS');
       ajdpss=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DEEP_DESCENT_END');
       ajdde=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DEEP_DESCENT_END_STATUS');
       ajddes=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DEEP_ASCENT_START');
       ajdas=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_DEEP_ASCENT_START_STATUS');
       ajdass=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_FIRST_MESSAGE');
       ajfm=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_FIRST_MESSAGE_STATUS');
       ajfms=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_FIRST_LOCATION');
       ajfl=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_FIRST_LOCATION_STATUS');
       ajfls=netcdf.getVar(fidh,thevar);     
       thevar=netcdf.inqVarID(fidh,'JULD_LAST_MESSAGE');
       ajlm=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_LAST_MESSAGE_STATUS');
       ajlms=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_LAST_LOCATION');
       ajll=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'JULD_LAST_LOCATION_STATUS');
       ajlls=netcdf.getVar(fidh,thevar);
       
       thevar=netcdf.inqVarID(fidh,'DATA_MODE');
       admode=netcdf.getVar(fidh,thevar);
 
       thevar=netcdf.inqVarID(fidh,'GROUNDED');
       agrnd=netcdf.getVar(fidh,thevar);
   
       
       thevar=netcdf.inqVarID(fidh,'CLOCK_OFFSET');
       aclock_off=netcdf.getVar(fidh,thevar);       
       
       thevar=netcdf.inqVarID(fidh,'REPRESENTATIVE_PARK_PRESSURE');
       arpp=netcdf.getVar(fidh,thevar);
       thevar=netcdf.inqVarID(fidh,'REPRESENTATIVE_PARK_PRESSURE_STATUS');
       arpps=netcdf.getVar(fidh,thevar);
       
       thevar=netcdf.inqVarID(fidh,'CONFIG_MISSION_NUMBER');
       acmnum=netcdf.getVar(fidh,thevar);
       
         % try putting in some safeguard to prevent data from being repeated 
       % getting lots of CSIRO floats with repeated jday
       
       
       % set c_len or biggest cycle number.  can't have a cycle zero since
       % i use this to set the size of the matrices.  
       if admode(end)=='D'
           c_len=max(cnum_adj)
          if min(cnum_adj(cnum_adj>=0))==0
              c_len=c_len+1
          end
       elseif admode(end)=='R' | admode(end)=='A'
          c_len=max(cnum)
          if min(cnum(cnum>=0))==0
              c_len=c_len+1
          end
       end
       
          
             % pre-allocate arrays
            jae=zeros(c_len,1)+NaN;
            jaes=char(zeros(c_len,1));
            jas=zeros(c_len,1)+NaN;
            jass=char(zeros(c_len,1));
            jds=zeros(c_len,1)+NaN;
            jdss=char(zeros(c_len,1));
            jde=zeros(c_len,1)+NaN;
            jdes=char(zeros(c_len,1));
            jdst=zeros(c_len,1)+NaN;
            jdsts=char(zeros(c_len,1));
            jte=zeros(c_len,1)+NaN;
            jtes=char(zeros(c_len,1));
            jfs=zeros(c_len,1)+NaN;
            jfss=char(zeros(c_len,1));
            jas=zeros(c_len,1)+NaN;
            jass=char(zeros(c_len,1));
            jps=zeros(c_len,1)+NaN;
            jpss=char(zeros(c_len,1));
            jpe=zeros(c_len,1)+NaN;
            jpes=char(zeros(c_len,1));
            jdps=zeros(c_len,1)+NaN;
            jdpss=char(zeros(c_len,1));
            jdde=zeros(c_len,1)+NaN;
            jddes=char(zeros(c_len,1));
            jdas=zeros(c_len,1)+NaN;
            jdass=char(zeros(c_len,1));
            jfm=zeros(c_len,1)+NaN;
            jfms=char(zeros(c_len,1));
            jfl=zeros(c_len,1)+NaN;
            jfls=char(zeros(c_len,1));
            jlm=zeros(c_len,1)+NaN;
            jlms=char(zeros(c_len,1));
            jll=zeros(c_len,1)+NaN;
            jlls=char(zeros(c_len,1));
            dmode=char(zeros(c_len,1));
            grnd=char(zeros(c_len,1));
            clock_off=zeros(c_len,1)+NaN;
            rpp=zeros(c_len,1)+NaN;
            rpps=char(zeros(c_len,1));
            cmnum=zeros(c_len,1)+NaN;
            
       
       % only want floats with more than one cycle since i'm interested in
       % drift velocities.  
if c_len<=1 
    xlat=0;
    xlon=0;
    jday=0;
    pac=' ';
    pressure=0;
    temp=0;
    jas=ajas;
    jae=ajae;
    jds=ajds;
    jde=ajde;
    jaes=ajaes;
    jass=ajass;
    jdss=ajdss;
    jdes=ajdes;
    jdst=ajdst;
    jdsts=ajdsts;
    cycles=0;
    nlat=0;
    rxlat=0;
    rxlon=0;
    rjday=0;
    rpac=' ';
    dmode=admode;
    continue
    
elseif c_len>1
% now need to adjust for fact that cycle number is skipped if there are
% missing cycles

% now need to adjust for fact that cycle number is skipped if there are
% missing cycles

% first do a quick check for missing cycles
B=1:c_len;
missingcyc=setdiff(B,cnum_ind);
missingcyc_d=setdiff(B,cnum_ind_adj);

if isempty(missingcyc)==1
    'no missing cycles in cnum_ind'
    pause
else
    
    % go through each cycle and create cycle timing variables
for kd=1:c_len
    
    % see if cycle is in N_CYCLE arrays
    yescyc=find(cnum_ind==kd);
    yescyc_d=find(cnum_ind_adj==kd);
    
    if isempty(yescyc_d)==1  % no dmode cycles
        if isempty(yescyc)==1  % no real time cycles either
            jae(kd)=999999;
            jaes(kd)=' ';
            jas(kd)=999999;
            jass(kd)=' ';
            jds(kd)=999999;
            jdss(kd)=' ';
            jde(kd)=999999;
            jdes(kd)=' ';
            jdst(kd)=999999;
            jdsts(kd)=' ';
            jte(kd)=999999;
            jtes(kd)=' ';
            jfs(kd)=999999;
            jfss(kd)= ' ';
            jas(kd)=999999;
            jass(kd)=' ';
            jps(kd)=999999;
            jpss(kd)=' ';
            jpe(kd)=999999;
            jpes(kd)=' ';
            jdps(kd)=999999;
            jdpss(kd)=' ';
            jdde(kd)=999999;
            jddes(kd)=' ';
            jdas(kd)=999999;
            jdass(kd)=' ';
            jfm(kd)=999999;
            jfms(kd)=' ';
            jfl(kd)=999999;
            jfls(kd)=' ';
            jlm(kd)=999999;
            jlms(kd)=' ';
            jll(kd)=999999;
            jlls(kd)=' ';
            dmode(kd)=' ';
            grnd(kd)=' ';
            clock_off(kd)=0;
            rpp(kd)=99999;
            rpps(kd)=' ';
            cmnum(kd)=99999;
            
        elseif isempty(yescyc)==0 % yes, a real time cycle
            jae(kd)=ajae(yescyc);
            jaes(kd)=ajaes(yescyc);
            jas(kd)=ajas(yescyc);
            jass(kd)=ajass(yescyc);
            jds(kd)=ajds(yescyc);
            jdss(kd)=ajdss(yescyc);
            jde(kd)=ajde(yescyc);
            jdes(kd)=ajdes(yescyc);
            jdst(kd)=ajdst(yescyc);
            jdsts(kd)=ajdsts(yescyc);
            jte(kd)=ajte(yescyc);
            jtes(kd)=ajtes(yescyc);
            jfs(kd)=ajfs(yescyc);
            jfss(kd)=ajfss(yescyc);
            jas(kd)=ajas(yescyc);
            jass(kd)=ajass(yescyc);
            jps(kd)=ajps(yescyc);
            jpss(kd)=ajpss(yescyc);
            jpe(kd)=ajpe(yescyc);
            jpes(kd)=ajpes(yescyc);
            jdps(kd)=ajdps(yescyc);
            jdpss(kd)=ajdpss(yescyc);
            jdde(kd)=ajdde(yescyc);
            jddes(kd)=ajddes(yescyc);
            jdas(kd)=ajdas(yescyc);
            jdass(kd)=ajdass(yescyc);
            jfm(kd)=ajfm(yescyc);
            jfms(kd)=ajfms(yescyc);
            jfl(kd)=ajfl(yescyc);
            jfls(kd)=ajfls(yescyc);
            jlm(kd)=ajlm(yescyc);
            jlms(kd)=ajlms(yescyc);
            jll(kd)=ajll(yescyc);
            jlls(kd)=ajlls(yescyc);
            dmode(kd)=admode(yescyc);
            grnd(kd)=agrnd(yescyc);
            clock_off(kd)=aclock_off(yescyc);
            rpp(kd)=arpp(yescyc);
            rpps(kd)=arpps(yescyc);
            cmnum(kd)=acmnum(yescyc);
        end
    elseif isempty(yescyc_d)==0  % yes dmode cycle
        jae(kd)=ajae(yescyc_d);
            jaes(kd)=ajaes(yescyc_d);
            jas(kd)=ajas(yescyc_d);
            jass(kd)=ajass(yescyc_d);
            jds(kd)=ajds(yescyc_d);
            jdss(kd)=ajdss(yescyc_d);
            jde(kd)=ajde(yescyc_d);
            jdes(kd)=ajdes(yescyc_d);
            jdst(kd)=ajdst(yescyc_d);
            jdsts(kd)=ajdsts(yescyc_d);
            jte(kd)=ajte(yescyc_d);
            jtes(kd)=ajtes(yescyc_d);
            jfs(kd)=ajfs(yescyc_d);
            jfss(kd)=ajfss(yescyc_d);
            jas(kd)=ajas(yescyc_d);
            jass(kd)=ajass(yescyc_d);
            jps(kd)=ajps(yescyc_d);
            jpss(kd)=ajpss(yescyc_d);
            jpe(kd)=ajpe(yescyc_d);
            jpes(kd)=ajpes(yescyc_d);
            jdps(kd)=ajdps(yescyc_d);
            jdpss(kd)=ajdpss(yescyc_d);
            jdde(kd)=ajdde(yescyc_d);
            jddes(kd)=ajddes(yescyc_d);
            jdas(kd)=ajdas(yescyc_d);
            jdass(kd)=ajdass(yescyc_d);
            jfm(kd)=ajfm(yescyc_d);
            jfms(kd)=ajfms(yescyc_d);
            jfl(kd)=ajfl(yescyc_d);
            jfls(kd)=ajfls(yescyc_d);
            jlm(kd)=ajlm(yescyc_d);
            jlms(kd)=ajlms(yescyc_d);
            jll(kd)=ajll(yescyc_d);
            jlls(kd)=ajlls(yescyc_d);
            dmode(kd)=admode(yescyc_d);
            grnd(kd)=agrnd(yescyc_d);
            clock_off(kd)=aclock_off(yescyc_d);
            rpp(kd)=arpp(yescyc_d);
            rpps(kd)=arpps(yescyc_d);
            cmnum(kd)=acmnum(yescyc_d);
    end
end % kd loop
end % missing cyc loop


                       
        
            
           
       
       
       % just do a quick comparison of cycle number to see if there are
       % changes
       if c_len > 1
       if isequal(cnum_ind,cnum_ind_adj)~=1 & strcmp(dmode(2),'D')==1 & strcmp(dmode(end),'R')~=1
           'cycle number has been adjusted'
           pause
       end
       end
    
          
       
                    
             
% end
% end
% 
         
         % ok, now everything is loaded in. 
         % now get primary mcodes - won't get all mcodes
         mc100=find(mcode==100); % DST
         mc150=find(mcode==150); % FST
         mc200=find(mcode==200); % DET
         mc250=find(mcode==250); % PST
         mc300=find(mcode==300); % PET
         mc400=find(mcode==400); % DDET
         mc450=find(mcode==450); % DPST
         mc500=find(mcode==500); % AST
         mc550=find(mcode==550); % DAST
         mc600=find(mcode==600); % AET
         mc700=find(mcode==700); % TST
         mc701=find(mcode==701); % TST APEX
         mc702=find(mcode==702); % FMT
         mc703=find(mcode==703); % surface times
         mc704=find(mcode==704); % LMT
         mc800=find(mcode==800); % TET
         mc301=find(mcode==301); % rpp
         mc296=find(mcode==296); % average drifts
         mc290=find(mcode==290); % series of drifts
         mc299=find(mcode==299); % spot sampled drift        
   

         % now begin to build up matrices based on number of cycles
         % reported and the most number of surface locations


%       find cycle with most surface fixes and use that to set array size
        dima=mode(cnum(mc703));
        dimac=find(cnum(mc703)==dima);
        dimal=length(dimac);  
         %pause
         

         sday(1,1:c_len)=jfm;
         sday(2,1:c_len)=jlm;
         
         % set up blank arrays with 0's or spaces
         jday(1:dimal,1:c_len)=0;
         jdays(1:dimal,1:c_len)=' ';
         jday_adj(1:dimal,1:c_len)=0;
         jdays_adj(1:dimal,1:c_len)=' ';
         xlat(1:dimal,1:c_len)=0;
         xlon(1:dimal,1:c_len)=0;
         pac(1:c_len,1:dimal)=' ';
         jday_qc(1:c_len,1:dimal)=' ';
         jday_adj_qc(1:c_len,1:dimal)=' ';
         pos_qc(1:c_len,1:dimal)=' ';
         
         cyclesf=unique(cnum);
         % can't have a negative number as an index
         if cyclesf(1)==-1
             cycles=cyclesf(2:end);
         elseif cyclesf(1)>=0
             cycles=cyclesf;
         end
        % pause
         % must loop through each cycle to read in the information
         for kc=1:c_len
             % try a fix for cycle 0
             if cycles(1)==0
                 kc_ind=kc-1; 
             elseif cycles(1)~=0
                 kc_ind=kc;
             end
             
             % look for all surface positions with the current cycle number
             % (kc_ind)
             mckc=find(mcode==703 & cnum==kc_ind);
             mc2kc=find(mcode==702 & cnum==kc_ind);
             mc4kc=find(mcode==704 & cnum==kc_ind);

            
                     
            % fill juld and juld_adjusted variables
             jday(1:length(mckc),kc)=juld(mckc);
             jday_adj(1:length(mckc),kc)=juld_adj(mckc);
             jdays(1:length(mckc),kc)=julds(mckc);
             jdays_adj(1:length(mckc),kc)=julds_adj(mckc);
             
             pac(kc,1:length(mckc))=pacm(mckc);
             jday_qc(kc,1:length(mckc))=juld_qc(mckc)';
             jday_adj_qc(kc,1:length(mckc))=juld_adj_qc(mckc)';
             

             % use position qc flags to only put in positions with a qc of
             % '1'
   
             for qf=1:length(mckc)
               
                 if qc(mckc(qf))=='1' 
                     
                     xlat(qf,kc)=lat(mckc(qf));
                     xlon(qf,kc)=lon(mckc(qf));
                   
                  elseif qc(mckc(qf))~='1'
                      
                     xlat(qf,kc)=0;
                     xlon(qf,kc)=0;
                 end
             end
        
             nlat(1,kc)=length(mckc);
             
             pos_qc(kc,1:length(mckc))=qc(mckc)';                                                
     
             
     
             
             % get temp, pres, psal
             % ideally, rpp is the best drift measurement
             % first determine if using temp or temp_adj

             rppcode=find(mcode==301 & cnum==kc_ind);
             if isempty(rppcode)==1
%                  'no drift this cycle'
                 temp(:,kc)=0;
                 pressure(:,kc)=0;
                 psal(:,kc)=0;
             end
             % best option
             if isempty(rppcode)==0
                 % find out mode of cycle
                 if dmode(kc)=='D'
                     % use adj variables
                     temp(1:length(rppcode),kc)=tempm_adj(rppcode);
                     pressure(1:length(rppcode),kc)=presm_adj(rppcode);
                     psal(1:length(rppcode),kc)=psalm_adj(rppcode);
                 elseif dmode(kc)=='R' | dmode(kc)=='A'
                     % use adj variables if filled and qc =='1', otherwise,
                     % use raw variables if filled and qc =='1'                     
                     %'in R area for temp'
                     % pause
                     if tempm_adj(rppcode)~=99999
                         temp(1:length(rppcode),kc)=tempm_adj(rppcode);
                     elseif tempm_adj(rppcode)==99999
                         temp(1:length(rppcode),kc)=tempm(rppcode);
                     end

                     if presm_adj(rppcode)~=99999
                         pressure(1:length(rppcode),kc)=presm_adj(rppcode);
                     elseif presm_adj(rppcode)==99999
                         pressure(1:length(rppcode),kc)=presm(rppcode);
                     end

                     if psalm_adj(rppcode)~=99999
                         psal(1:length(rppcode),kc)=psalm_adj(rppcode);
                     elseif psalm_adj(rppcode)==99999
                         psal(1:length(rppcode),kc)=psalm(rppcode);
                     end
                 elseif dmode(kc)==' '
                     temp(1:length(rppcode),kc)=0;
                     pressure(1:length(rppcode),kc)=0;
                     psal(1:length(rppcode),kc)=0;
                 end
             end  % isempty(rppcode)
              
             

             % if no rppcode, then must find drift measurements
             if isempty(rppcode)==1 | tempm(rppcode)==99999
%                  'no rppcode or it is only for pressure'
%                  no_pts=[no_pts;kk];
%                  
                 % figure out what to do with measurements
                 % first look for averages
                 avgmeas=find(mcode==296 & cnum==kc_ind);
                     % next look for series of samples
                     if isempty(avgmeas)==1
                         avgmeas=find(mcode==290 & cnum==kc_ind);
                     end
                     % next look for median
                     if isempty(avgmeas)==1
                          avgmeas=find(mcode==295 & cnum==kc_ind);
                     end
                     % next look for max and min
                     if isempty(avgmeas)==1
                          avgmeas=find( (mcode==297 | mcode==298) & cnum==kc_ind);
                          if isempty(avgmeas)==0
                            'only min and max drift values'
                            pause
                          elseif isempty(avgmeas)==1
                              % can't find any drift measurements - put in
                              % a zero
                               'no drift this cycle'
                                temp(:,kc)=0;
                                 pressure(:,kc)=0;
                                 psal(:,kc)=0;
                          end                              
                     end
                     
                     if isempty(avgmeas)==0
                         if tempm_adj(avgmeas)~=99999                     
                             temp(1,kc)=mean(tempm_adj(avgmeas));
                         elseif tempm_adj(avgmeas)==99999
                             temp(1,kc)=mean(tempm(avgmeas));
                         end
                 
                         if psalm_adj(avgmeas)~=99999
                             psal(1,kc)=mean(psalm_adj(avgmeas));
                         elseif psalm_adj(avgmeas)==99999
                             psal(1,kc)=mean(psalm(avgmeas));
                         end
                        
                 
                        % only fill pressure if it isn't already filled
                            if pressure(1,kc)==99999 | pressure(1,kc)==0
                                cc=[];
                                for pm=1:length(avgmeas)
                                    cc=[cc;'4'];
                                end
                                  if presm_adj(avgmeas)~=99999 
                                      if presm_adj_qc(avgmeas)~=cc
                                         pressure(1,kc)=mean(presm_adj(avgmeas));
                                      elseif presm_adj_qc(avgmeas)==cc
                                          pressure(1,kc)=0;
                                      end
                                  elseif presm_adj(avgmeas)==99999 
                                      % don't want to use pres just because
                                      % pres_adj is fill value.  want to
                                      % make sure that pres_adj is either
                                      % in dmode OR pres qc is good
                                      if presm_adj_qc(avgmeas)~=cc
                                        if presm_qc(avgmeas)~=cc 
                                            % use only good presm
                                            agcc=[];
                                            for gl=1:length(avgmeas)
                                                gcc=find(strcmp(presm_qc(avgmeas(gl)),'1')== 1 ...
                                                    | strcmp(presm_qc(avgmeas(gl)),'0')==1);
                                                agcc=[agcc;gcc];
                                            end
                                            mean(presm(avgmeas(agcc)))  ;
                                            % don't use if it is empty
                                            if isempty(agcc)==0
                                                pressure(1,kc)=mean(presm(avgmeas(agcc)));
                                                temp(1,kc)=mean(tempm(avgmeas(agcc)));
                                            end
                                          elseif presm_qc(avgmeas)==cc
                                              pressure(1,kc)=0;
                                              temp(1,kc)=0;
                                        end
                                      elseif presm_adj_qc(avgmeas)==cc
                                          pressure(1,kc)=0;
                                      end
                                  end    

                            end
                    
                     elseif isempty(avgmeas)==1                                                             
                         'no drift this cycle'
                           temp(:,kc)=0;
                         pressure(:,kc)=0;
                         psal(:,kc)=0;
                     end % isempty(avgmeas)
             end % isepmty(rppcode) | tempm(rppcode)

             
         end % kc loop
             
             
             % just a check to see if my rpp matches the rpp in N_CYCLE
             % first make all fill values in rpp 0 to match
             fv=find(rpp==99999 |rpp==999999);
             rpp(fv)=0;
             if isequal(rpp,pressure)==0
                 if rpp~=0
                  pressure'-rpp
                 'rpp not equal to my pressure'           
                 pause
                 end
             end
             
end
end

