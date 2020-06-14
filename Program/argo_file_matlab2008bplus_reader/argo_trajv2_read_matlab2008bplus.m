% =================================================================================
%
% argo_trajv2_read_matlab2008bplus
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

%                       [m_len,c_len,qc,juld_qc,PI_name,xlat,xlon,jday,...
%                       grnd,pac,thepres,thetemp,thepsal,...
%                       jae,jas,jds,jde,...
%                       jaes,jass,jdss,jdes,jdst,jdsts,...
%                       plat,transmis_sys,cycles,nlat,dmode]=...
%                        argo_trajv2_read_matlab2008bplus(ncfil);
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

 % ncfil='1900728_traj.nc'



% ================================================================================
% % 



function  [m_len,c_len,qc,juld_qc,PI_name,xlat,xlon,jday,...
                      grnd,pac,thepres,thetemp,thepsal,...
                      jae,jas,jds,jde,...
                      jaes,jass,jdss,jdes,jdst,jdsts,...
                      plat,transmis_sys,cycles,nlat,dmode]=...
                       argo_trajv2_read_matlab2008bplus(ncfil);

for xx=1:1



       fidh= netcdf(ncfil, 'nowrite');  % Open NetCDF file
       
       
       thevar=fidh{'PI_NAME'};
       PI_name=thevar(:);
       
       thedim=fidh('N_MEASUREMENT');
       m_len=length(thedim);
       thedim=fidh('N_CYCLE');
       c_len=length(thedim)
       thevar=fidh{'CYCLE_NUMBER'};
       cnum=[];
       cnum(1:m_len)=thevar(1:m_len);
       
       thevar=fidh{'POSITIONING_SYSTEM'};
       transmis_sys=thevar(:);
       thevar=fidh{'INST_REFERENCE'};
       plat=thevar(:);

    % check size of transmis_sys to make sure it gets read properly
    lts=length(transmis_sys);
    if lts>8
        transmis_sys=transmis_sys(1:8);
    end
    
   
   
   % sometimes DACs add extra to c_len, so reduce it if not needed
   no9cnum=find(cnum~=99999);
   tclen=max(cnum(no9cnum));
   
   if tclen+1<c_len%tclen+1<c_len  %%% works well for c_len==max(cnum) for apex at coriolis
       c_len=tclen
       'new c_len because old was too big'
   end
   
    % problem when c_len==tclen & first cycle is 0  %%% gives problems if
    % traj file is poorly written
  
    if tclen==c_len & cnum(1)==0
        c_len=c_len+1;
        'new c_len because old was too small'
    end
   qc=[];
   juld_qc=[];
     jde=[];
   jdes=[];
   jds=[];
   jdss=[];
   jae=[];
   jaes=[];
   jas=[];
   jass=[];
   jdst=[];
   jdsts=[];
   miss_cyc=[];
   bad_cor_indexing=[];
   xlat=[];      nlat=[];       
   xlon=[];     
   jday=[];      
   pqt=[];          cjday=[];
   grnd=' ';        clear cpac
   pac=[];
   ipac=' ';

  
 


   if c_len==1 || c_len==2 || m_len==1 || m_len==2
    % fill in the missing cycle with fill value
         xlat=0;
         xlon=0;
         jday=0;
         grnd='U';
         pac=' ';
         cycles=0;
         dmode=' ';
         
     
   elseif c_len>2
   
   
  
     % define all the matrices for the things that will be big

xlat=zeros(50,c_len)+NaN;
xlon=zeros(50,c_len)+NaN;
jday=zeros(50,c_len)+NaN;
nlat=zeros(1,c_len)+NaN;
ipac=char(32*ones(50,c_len));
pos_qc=char(32*ones(50,c_len));
   if  m_len==1 || m_len==2
    % fill in the missing cycle with fill value
         xlat=0;
         xlon=0;
         jday=0;
         grnd='U';
         pac=' ';
         cycles=0;
   end

       
       
   thevar=fidh{'POSITION_QC'};
   qc=thevar(1:m_len);
   thevar=fidh{'JULD_QC'};
   juld_qc=thevar(1:m_len);
%    %        % now get all the timing variables
       thevar=fidh{'JULD_ASCENT_END'};
       jae=thevar(:);
       thevar=fidh{'JULD_ASCENT_START'};
       jas=thevar(:);
       thevar=fidh{'JULD_DESCENT_START'};
       jds=thevar(:);
       thevar=fidh{'JULD_DESCENT_END'};
       jde=thevar(:);
       thevar=fidh{'JULD_START_TRANSMISSION'};
       jdst=thevar(:);
       if isempty(jdst)==1
       thevar=fidh{'JULD_TRANSMISSION_START'};
       jdst=thevar(:);
       end
       thevar=fidh{'JULD_ASCENT_END_STATUS'};
       jaes=thevar(:);
       thevar=fidh{'JULD_ASCENT_START_STATUS'};
       jass=thevar(:);
       thevar=fidh{'JULD_DESCENT_START_STATUS'};
       jdss=thevar(:);
       thevar=fidh{'JULD_DESCENT_END_STATUS'};
       jdes=thevar(:);
       thevar=fidh{'JULD_START_TRANSMISSION_STATUS'};
       jdsts=thevar(:);
       thevar=fidh{'LATITUDE'};
       thelat=thevar(:);
       thevar=fidh{'LONGITUDE'};
       thelon=thevar(:);
       thevar=fidh{'JULD'};
       thejuld=thevar(:);
       thevar=fidh{'TEMP'};
       thetemp=thevar(:);
       thevar=fidh{'PRES'};
       thepres=thevar(:);
       thevar=fidh{'PSAL'};
       thepsal=thevar(:);
       thevar=fidh{'POSITION_ACCURACY'};
       thepac=thevar(:);
       thevar=fidh{'GROUNDED'};
       theground=thevar(:);
       
       thevar=fidh{'DATA_MODE'};
       admode=thevar(:);
       
       cycles=unique(cnum);
        % cycles becomes a problem when cnum==0 since it is used as an
        % index later
        if cycles(1)==0
            cycles=cycles+1;

        end




 start=min(cnum);
 


   for kc=1:c_len

bad_indexing=[];


% some files have non-consecutive cycle numbers - check for this first
 whichis=find(cnum(:)==start-1+kc);
col=kc;


if col>c_len
    continue
end

if isempty(whichis)==1 
    'missing cycle number'
    miss_cyc=[miss_cyc;[kk,col]];
    [xas xbs]=size(xlat);
    xlat(1:xas,col)=0;
    xlon(1:xas,col)=0;
    jday(1:xas,col)=0;
    grnd(col)='U';
    [ps pt]=size(pac);
    pac(col,1:pt)=' ';
    endnan=find(isnan(nlat)==1);
    nlat(endnan(1))=0;
    lengthlat=[];
    nlat(col)=0;
    continue
end


whichis=find(cnum(:)==start-1+kc);
 
        knt(kc)=length(whichis);
        
        
for xr=1:knt(kc)-1
    if whichis(xr+1)~=whichis(xr)+1
        whichis(xr+1);
        bad_indexing=[bad_indexing,xr];
    end
end


             

 if isempty(bad_indexing)==0 
     'bad_indexing'
     whichis
     cnum(whichis(1):whichis(end))
     bad_data=[bad_data;[kk,col]];
     [xas xbs]=size(xlat);
     xlat(1:xas,col)=0;
     xlon(1:xas,col)=0;
     jday(1:xas,col)=0;
     grnd(col)='U';
     [ps pt]=size(pac);
     pac(col,1:pt)=' ';
     endnan=find(isnan(nlat)==1);
     nlat(endnan(1))=0;
     lengthlat=[];
     nlat(col)=0;
     knlat(col)=0;
    continue
end

    

%         
     if(~isempty(whichis))
             
%         
        thevar=thelat;
       
        if kc==1
            % check for later to see if we are getting all latitudes
            no9alllat=find(thevar(:)~=99999);
            % do a special whichis to get rid of Cy0
            
            
            whichis0=find(cnum(:)==start);
            no9cy0=find(thevar(whichis0)~=99999);
            if start <=1
                lengthlat=length(no9alllat)-length(no9cy0);
            elseif start >1
                lengthlat=length(no9alllat);
            end
        end
        
        %%%%%%%%%%%
      
        
        
        no9lat=find(thevar(whichis)~=99999);  
       
       if isempty(no9lat)==0
       which=whichis(no9lat(1):no9lat(end)); % can't do straight no9lat b/c of 
        % random 99999 thrown in
        
 



if strcmp(transmis_sys,'IRIDIUM ')~=1 & ...
        strcmp(transmis_sys,'GPS     ')~=1
    
       xlat(which-which(1)+1,col)=thelat(which,1);

       xlon(which-which(1)+1,col)=thelon(which,1);

       jday(which-which(1)+1,col)=thejuld(which,1);

elseif strcmp(transmis_sys,'IRIDIUM ')==1 | ...
        strcmp(transmis_sys,'GPS     ')==1


    % use position qc flags
    % not for cycle 0
    if start-1+kc==0
        xlat(1:2,col)=0;
        xlon(1:2,col)=0;
    else
             for qf=1:length(which)
                 if qc(which(qf))=='1' 
                     xlat(qf,col)=thelat(which(qf));
                     xlon(qf,col)=thelon(which(qf));
                 elseif qc(which(qf))~='1' & qc(which(qf))~='0'
                     xlat(qf,col)=0;
                     xlon(qf,col)=0;
                 end
             end
    end
   
       jday(1:length(which),col)=thejuld(which,1);
       pos_qc(1:length(which),col)=qc(which);


       
end




       grnd(col)=theground(col);
       dmode(col)=admode(col);


       ipac(which-which(1)+1,col)=thepac(which);
       pac=ipac';


   %Find all positions that are nonzero
 

      x = find(xlat(:,col)~=0 & xlat(:,col)~=99999);
      % problem is this skips place where lat is actually 0
      if length(x)~=length(which) % there is a zero or a 99999 somewhere
          x0=find(xlat(:,col)==0);
          x9=find(xlat(:,col)==99999);
          % check to see if a fill value is in there
          if length(x9)>0
              'fill value - it is ok'
              add0=0;
              
          elseif isempty(x9)==1
              % 'no fill value - add on some length'
              % make lowest numbered x0 a true zero
              % get length
              add0=length(which)-length(x);%length(x0);
          end
      elseif length(x)==length(which)
          add0=0;
      end
              
             
      latlen=size(x);
      nl=latlen(1,1);
      nlat(col) = nl+add0;
      if start-1+kc==0
          nlat(1)=0;
      end
      % check to see if we are getting all the lats
      if nlat(col) ~=length(no9lat)
          'diff lat length'
          col
          %pause
      end
   
   
   
          

       elseif isempty(no9lat)==1  
           [xas xbs]=size(xlat);
           xlat(1:xas,col)=0;
           xlon(1:xas,col)=0;
           jday(1:xas,col)=0;
           grnd(col)='U';
           [ps pt]=size(pac);
           pac(col,1:pt)=' ';
           nlat(col)=0;
         
       end % isempty(no9lat) loop

     elseif isempty(whichis)==1 
         % fill in the missing cycle with fill value
         [xas xbs]=size(xlat);
         xlat(1:xas,col)=0;
         xlon(1:xas,col)=0;
         jday(1:xas,col)=0;
         grnd(col)='U';
         [ps pt]=size(pac);
         pac(col,1:pt)=' ';
         nlat(col)=0;

         
     end; %isempty(whichis) loop

             
   end % kc  loop

   end;  %c_len >2 loop

   
     result=close(fidh);

     % get rid of all NaNs & shrinking xlat, xlon, jday, pac
     if exist('nlat')==1
if isempty(nlat)~=1
maxnlat=max(nlat);
xlat=xlat(1:maxnlat,:);
xlon=xlon(1:maxnlat,:);
jday=jday(1:maxnlat,:);
pac=pac(:,1:maxnlat);
xlat(isnan(xlat))=0;
xlon(isnan(xlon))=0;
jday(isnan(jday))=0;
nlat(isnan(nlat))=0;
end
     end
         
end  % for xx loop





    
      