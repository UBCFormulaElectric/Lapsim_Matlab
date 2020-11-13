function [CfdragT, CfdownT] = AeroMap(AP)

    %Af combination 
    
    CfdragT = AP.CfdragBdy*AP.Afbdy + AP.CfdragFW*AP.AfFW + AP.CfdragRW*AP.AfRW;  % = CfdragBdy*AfBdy + CfdragFW*AfFW + CfdragRW*AfRW
    CfdownT = AP.CfdownRW*AP.AfRW + AP.CfdownFW*AP.AfFW;  % = CfdownRW*AfRW + CfdownFW*AfFW;
    
   


end