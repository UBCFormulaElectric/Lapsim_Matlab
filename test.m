function F = root4d(x)

F(1) = x(1) - x(4) - 20;
F(2) = x(2) + x(3) -30
F(3) = x(1)^2 + x(2)^2 - 40^2;
F(4) = x(3)*0.4  - x(2)*0.7 - 2;

fun = @root4d;
x0 = [0,0,0,0];
x = fsolve(fun,x0)