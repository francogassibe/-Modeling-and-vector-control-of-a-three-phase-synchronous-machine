close all
clc
clear

%Datos tensiones

vf_a = (24/sqrt(3))*sqrt(2);
f=60;

%%DATOS CONSTRUCTIVOS SUBSISTEMA ELECTRICO
Jm = 3.1e-6;
Bm = 1.5e-5;
Pp = 3;
%%

Lamdam = 0.01546;
Lq = 5.8e-3;
Ld = 6.6e-3;
Lls = 0.8e-3;
rs = 1.02;

%%DATOS CONSTRUCTIVOS SUBSISTEMA MECANICO
r=314.3008;
Jl=0.2520;
Bl =0.0530*0;

%%DATOS TERMICOS
Cts = 1.091;
Rsref = 1.02;
alfacu = 3.9e-3;
Rst_amb = 55;
Tref = 40;
Tamb = 25;



%%CONDICIONES INICIALES
theta0 = 0;
w0 = 0;
iqr0 =0;
idr0 =0;
ioso=0;
Ts0=25;

%% Condiciones estacionarias

west = f*2*pi/Pp;
parest = west*Bm;

parest_qod = (3/2)*Pp*(Lamdam+(Ld-Lq)*(6.541))*0.01687;

%% Ids =0 
 
Jeq = Jm + Jl/(r^2);
Beq = Bm + Bl/(r^2);
KT = (3/2)*Pp*Lamdam;
KE=Pp*Lamdam;

A = [0 1 0;
0 -Beq/Jeq KT/Jeq;
0 -KE/Lq -rs/Lq];

B = [0 0;
-1/Jeq 0 ;
0 1/Lq];


C = [1 0 0];

%C = [B,A*B,.....,A^n-1*B]
Controlabiliad_Matrix = [0,                                      0,                                                                            (3*Lamdam*Pp)/(Lq*(2*Jm + (2*Jl)/r^2));
    0, (3*Lamdam*Pp)/(Lq*(2*Jm + (2*Jl)/r^2)), -((3*Lamdam*Pp*(Bm + Bl/r^2))/((Jm + Jl/r^2)*(2*Jm + (2*Jl)/r^2)) + (3*Lamdam*Pp*rs)/(Lq*(2*Jm + (2*Jl)/r^2)))/Lq;
 1/Lq,                               -rs/Lq^2,                                                       (rs^2/Lq^2 - (3*Lamdam^2*Pp^2)/(Lq*(2*Jm + (2*Jl)/r^2)))/Lq];


Observabilidad = [C;
                            C*A;
                            C*A*A];
I = ones(3,3);
                        


sistem = ss(A,B,C,0);

[a1,b1]=ss2tf(A,B(:,1),C,0);
[a2,b2]=ss2tf(A,B(:,2),C,0);






%% LPV

%Asumiendo que f(Xo(t),Uo(t)) =~ 0
Jeq = Jm + Jl/(r^2);
Beq = Bm + Bl/(r^2);

idso = 0;
iqso = 1;
wmo = 400;

aux23 = 3*Pp*(Lamdam + (Ld-Lq)*idso)/2*Jeq;
aux24 = 3*Pp*(Ld-Lq)*iqso/2*Jeq;
aux32 = Pp*(Lamdam + Ld*idso)/-Lq;
aux34 = Ld*Pp*wmo/-Lq;
aux42 = Lq*iqso*Pp/Ld;
aux43 = Lq*Pp*wmo/Ld;

deltaA = [0       1          0       0      0;
                0  -Beq/Jeq  aux23  aux24 0;
                0    aux32   -rs/Lq   aux34 0;
                0    aux42    aux43  -rs/Ld  0;
                0       0            0          0  -rs/Lls];
                        
deltaB = [0 0 0;
               0 0 0;
               1/Lq 0 0;
               0 1/Ld 0;
               0 0 1/Lls];
           
 %% Control
 p=5000;
 Rq = p*Lq;
 Rd = p*Ld;
 Ro = p*Lls;
 
 ba=0.0113;
 Ksa = 9.04;
 Ksia = 2892.8;
 
 wobs=3200;
 Ktheta_obs  = wobs*3;
 Kw_obs= 3*3200^2;        
 Ki = wobs^3;
 


 %% Generacion perfil

tf=6;
dq=2*pi;
[tv1,tv2,tm,Amax,tr] = perfil_a(dq,tf);

%% Perfil

tr1 = tr
tp1 = tv1-2*tr
tp2 =  tv2-2*tr
tao = tm
Amax=Amax
tr2=tr


am=Amax;
tiempo_total=tr*4+tp1+tp2+tm;

qfinal=Amax*tr1^2 + (3/2)*Amax*tp1*tr1 +(Amax/2)*tp1^2 + (tr1+tp1)*Amax*tao + ... 
            tr1*Amax*tr1 + tp1*Amax*tr1 - (am/6)*tr1^2 + ...
            tr1*Amax*tp2 + tp1*Amax*tp2 - (am/2)*tr1*tp2 - (am/2)*tp2^2 + ... 
            tr1*Amax*tr1 + tp1*Amax*tr1 - am*tr1^2 - tp2*am*tr1 + (am/6)*tr1^2
        
tiempos_perfild=[0 2 2+tr1 2+tr1+tp1 2+2*tr1+tp1 2+2*tr1+tp1+tao  tao+2+2*tr1+tp1+tr1  tao+2+2*tr1+tp1+tr1+tp2 tao+2+2*tr1+tp1+tr1+tp2+tr1 tao+2+2*tr1+tp1+tr1+tp2+tr1+2] 
acels_perfild=[0 0 Amax Amax 0 0  -Amax -Amax 0 0]

tiempos_perfili=[2 2+tr1 2+tr1+tp1 2+2*tr1+tp1 2+2*tr1+tp1+tao  tao+2+2*tr1+tp1+tr1  tao+2+2*tr1+tp1+tr1+tp2 tao+2+2*tr1+tp1+tr1+tp2+tr1 tao+2+2*tr1+tp1+tr1+tp2+tr1+2]+tao+2+2*tr1+tp1+tr1+tp2+tr1+2
acels_perfili=[0 -Amax -Amax 0 0  Amax Amax 0 0]

tiempos_perfil=[tiempos_perfild,tiempos_perfili]
acels_perfil=[acels_perfild,acels_perfili]

tiempo_perfil_q=[0 2 7 12 17 22];
theta_perfil_q=[0 0 2*pi 2*pi 0 0];
 
 
 