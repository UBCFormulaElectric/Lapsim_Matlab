function c = curvefit(posi, posf, veli, velf)
    
    x1 = posi(1);
    y1 = posi(2);
    
    x2 = posf(1);
    y2 = posf(2);
    
    y1_dot = veli;
    y2_dot = velf;


    a = [ x1^3 x1^2 x1 1 y1; x2^3 x2^2 x2 1 y2; 3*x1^2 2*x1 1 0 y1_dot; 3*x2^2 2*x2 1 0 y2_dot];
    b = rref(a);
    
    c = [b(1,5), b(2,5), b(3,5), b(4,5)]
    




end