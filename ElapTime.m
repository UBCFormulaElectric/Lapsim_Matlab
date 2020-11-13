function [TotalT,SectorData] = ElapTime(CourseData, SectorData)

    %CourseData is an array containing information about the track data 
    % Firt Column : X - Coordinates of track
    % Second Column : Y - Coordinates of track
    % Third Column : Instantateous radius of the track at that point
    % Fourth Column : Legnth of sector, of the i to i+1 data point
    % Fifth Column : Theoretical max speed at that point
    
    %SectorData is an array containing information about the entry and exit
    %speeds of each ector
    %First Column : Velocity at each point assuming Only acceleration force
    %Second Column : Velocity at each point asusming only braking force
    %Thrid Column : Combined velocity profiles
    
    
    
    TotalT = 0;
    for i = 2:(length(SectorData)-1)
       
        Vavg = (real(SectorData(i,1))+ real(SectorData(i+1,1)))/2;
        
        dt =  CourseData(i,4)/Vavg;
        SectorData(i,4) = dt;
        TotalT = TotalT + dt;
    end
  
    SectorData(i+1,4) = 0;
    %disp(TotalT)



end