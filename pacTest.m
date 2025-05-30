clear; clc;

g = 9.81;
m = 0:50:400;

pac_fx = [ -15.75854662   1.43389415   3.343542286  0.91617855  ];
pac_fy = [   0.170613402  1.544452682  2.924301138  0.524592595 ];

slipAmax = 9.48021;
slipRmax = 0.123296;

Fz = [];
Fx = [];
Fy = [];

for i = 1:length(m)
    Fz(i) = m(i) * g;
    Fx(i) = Pacejka4(-Fz(i), slipRmax, pac_fx);
    Fy(i) = Pacejka4(-Fz(i), slipAmax, pac_fy);
end

plot(m,Fx,'r-'); hold on;
plot(m,Fy,'b-'); hold off;
legend('Fx vs m','Fy vs m')
xlabel('m (kg)')
ylabel('F (N)')