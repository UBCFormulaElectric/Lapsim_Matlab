function [TotalP,SectorData] = Power(CourseData, SectorData,CarMass)

      for i = 1:(length(SectorData)-1)
        SectorPower = CarMass*((SectorData(i+1,3)-SectorData(i,3))/SectorData(i,5))*CourseData(i,4);
        
        if SectorPower>0 
            
            SectorData(i,6) = SectorPower;
        else
            SectorData(i,6) = 0;
        end 
            
      end
    
      TotalP = sum(SectorData(:,6));
    TotalP = TotalP*32
    figure
    plot(SectorData(:,4),SectorData(:,6));
      
end