CrseData = xlsread('AutoXdata.xlsx','AutoX2015','A2:B151');   %Read Course Data as set of X,Y Coordinates from excel

[RefAutoXData] = RefineTrack(CrseData,2);

xlswrite('RefAutoXdata.xlsx',RefAutoXData)

%writematrix(NewCrseData(:,1:4),'RefAutoXdata.xlsx','Sheet 1')

