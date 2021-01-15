
syms tr1 tr2 tp1 tp2 t alfaM alfam



wmedio=1;
dq=2*pi;
dt=dq/wmedio;

% Fmax=2;
% alfaM=Fmax;
% alfam=alfaM;



tc=2*tr1+tp1;
ta=tr1;
tb=tr1+tp1;
td=2*tr1+tp1+tr2;
te=2*tr1+tp1+tr2+tp2;
tf=2*tr1+tp1+2*tr2+tp2;

m1=alfaM/ta;
m2=alfam/(td-tc);

C2=-ta*alfaM/2;
C3=tb*alfaM-m1/2*tc^2;
C4=alfaM*tb-m2/2*tc^2;
C5=(tb*alfaM-(td-tc)*alfam/2)+alfam*td;
C6=m2/2*tf^2;

q1=m1/6*t^3;
q2=alfaM/2*t^2+C2*t;
q3=-m1/6*t^3+m1*tc/2*t^2+C3*t;
q4=-m2/6*t^3+m2*tc/2*t^2+C4*t;
q5=-alfam/2*t^2+C5*t;
q6=m2/6*t^3-m2*tf/2*t^2+C6*t;

detlatheta=(subs(q1,t,ta)-subs(q1,t,0))+(subs(q2,t,tb)-subs(q2,t,ta))+(subs(q3,t,tc)-subs(q3,t,tb))+(subs(q4,t,td)-subs(q4,t,tc))+(subs(q5,t,te)-subs(q5,t,td))+(subs(q6,t,tf)-subs(q6,t,te))
simplify(detlatheta)
w3_tc=m1/2*tc^2+C3
wmax=800;
wfinal=tb*alfaM-(te-tc)*alfam

M=solve(dq==simplify(detlatheta),w3_tc-wmax==0,wfinal==0,tf-dt==0,tr1,tr2,tp1,tp2)
M.tr1
M.tr2
M.tp1
M.tp2



