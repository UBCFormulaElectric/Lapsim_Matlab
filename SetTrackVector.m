function SetTrackVector(CrseData)



  CrseData(1,7) = 0;                                           %Sets the values for direction vector and dtheta for the first segment
  CrseData(1,8) = 1;
  CrseData(1,9) = 0;
   


 for i = 2:length(CrseData)     
     
   %Loops through the course data to determine the direction unit vector
        
       if CrseData(i,3) == inf                                  %if the radius is infinite (ie a straight) a different algorith for determining vector is used
         
           xvec = CrseData(i+1,1) - CrseData(i,1);              %Calculates x and y components of vector
           yvec = CrseData(i+1,2) - CrseData(i,2);
           mag = sqrt(yvec^2 + xvec^2);                         %Calculates magnitude so vector can be normalized
           CrseData(i,7) = xvec/mag;
           CrseData(i,8) = yvec/mag;
           
       else
           
            yvec = CrseData(i,2) - CrseData(i,6);               %Otherwise direction vector is the vector perpendicular to vector from center of point
            xvec = CrseData(i,1) - CrseData(i,5);
            mag = sqrt(yvec^2 + xvec^2);
            CrseData(i,7) = yvec/mag;
            CrseData(i,8) = -1*(xvec/mag);
            
       end
        if i ~= 1                                                               %Determines unit vector direction based off whether different in angle between previous is greater than 90
       
            dtheta = atan2d(CrseData(i-1,7)*CrseData(i,8) - CrseData(i-1,8)*CrseData(i,7), CrseData(i-1,7)*CrseData(i,7) + CrseData(i-1,8)*CrseData(i,8));
        
        end 
        
        dtheta = abs(dtheta);
        
        if dtheta >= 90
            
            CrseData(i,7) = -1*(yvec/mag);
            CrseData(i,8) = xvec/mag;
            
        end
        
        CrseData(i,9) = deg2rad(atan2d(CrseData(i-1,7)*CrseData(i,8) - CrseData(i-1,8)*CrseData(i,7), CrseData(i-1,7)*CrseData(i,7) + CrseData(i-1,8)*CrseData(i,8)));
        
 end
 
 
 
    figure
    quiver(CrseData(:,1),CrseData(:,2),CrseData(:,7),CrseData(:,8))  

end