startDate = datenum('01-1-2015')
endDate = datenum('12-30-2019')
xData = linspace(startDate,endDate,8);
plot(xData,PC(1,:));
set(gca,'XTick',xData)
datetick('x','mm/dd/yyyy','keepticks')