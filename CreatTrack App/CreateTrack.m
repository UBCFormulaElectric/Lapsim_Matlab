function CreateTrack()

    
 
    h = imread('C:\Users\ryanc\Documents\Formula E\2021\200513_Modelling\Track Images\2018LincEndur_Crop.jpg'); 
    %h = image(xlim,-ylim,I); 
   
    image(h)
    %uistack(h,'bottom')
    axis('equal')
    hold on;
    i = 1;
    
    button = 1
    
    [x,y] = ginput(1);
    
    Cur_x = x;
    Cur_y = y;
    
    dCur = 1;
    
    
    while button ~= 116
        
       xlim([Cur_x-100, Cur_x+100]);
       ylim([Cur_y-100, Cur_y+100]);
        
        [x,y,button] = ginput(1);
        
        switch button
            case 28        
                Cur_x = Cur_x - dCur;
            case 29
                Cur_x = Cur_x + dCur;
            case 31
                Cur_y = Cur_y + dCur;
            case 30
                Cur_y = Cur_y - dCur;
        end
       
        h2 = scatter(Cur_x, Cur_y, 'r');
        
%        xlim([-100, x_C(i-2)+100])
%        ylim([y_C(i-2)-100, y_C(i-2)+100])
        
        
%     [x,y,button] = ginput(1)
%     
%     if button == 122
%        x_C(i-1) = NaN;
%        y_C(i-1) = NaN;
%        
%       
%         
%        i = i-2;
%         
%     else
%         x_C(i) = x;
%         y_C(i) = y;
%     
%         xlim([x-100, x+100])
%         ylim([y-100, y+100])
%     end
%     
%     x_C
%     y_C
%     scatter(x_C(:),y_C(:),'r.')
%     
    i = i+1;
    
    end



end