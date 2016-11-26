
clear
clc
format long


%%%%Initial conditions
yinit=1;
tinit=0;
time(1)=tinit;
tend=5;
%dt=1;
k=0;
l=0;
p=0;
q=0;




%m equals the number of simulations
%predefine result matrix size
m=4;
yeuler=zeros((-1+2^m)*(tend-tinit),1);
yheun=zeros((-1+2^m)*(tend-tinit),1);
yrunge=zeros((-1+2^m)*(tend-tinit),1);
y_anal=zeros((-1+2^m)*(tend-tinit),1);
time=zeros((-1+2^m)*(tend-tinit),1);

for j=0:m-1;
    dt=(1/2)^j;
n=(tend-tinit)/dt;
t=tinit:dt:tend;

%initial conditions updated for each new time step

time(k+1)=tinit;
yeuler(k+1)=yinit;
yheun(l+1)=yinit;
yrunge(p+1)=yinit;
y_anal(q+1)=yinit;
k=k+1;
l=l+1;
p=p+1;
q=q+1;

%%% EXPLICIT EULER

for i=2:n+1;
    time(k+1)=time(k)+dt;
yeuler(k+1)=yeuler(k)+dt*differential(yeuler(k));
k=k+1;
end


%%%HEUN METHOD



for i=2:n+1;
    
yheun(l+1)=yheun(l)+dt*0.5*(differential(yheun(l))+differential(yheun(l)+dt*differential(yheun(l))));
l=l+1;
end



%%% RUNGE KUTTA 4TH ORDER

for i=2:n+1;
    k1=differential(yrunge(p));
    k2=differential(yrunge(p)+dt*0.5*k1);
    k3=differential(yrunge(p)+dt*0.5*k2);
    k4=differential(yrunge(p)+dt*k3);
    yrunge(p+1,1)=yrunge(p)+dt*(k1+2*k2+2*k3+k4)/6;
    p=p+1;
end
    
%EXACT SOLUTION

for i=2:n+1;
    y_anal(q+1)=exact(time(q));
    q=q+1;
end







end


%plotting (muahahhahahaha)

%euler
        figure(1)
    plot(time(1:6),yeuler(1:6))
    hold on
for j=1:m-1;
    figure(1)
    plot(time(j-4+5*2^j:j-4+5*2^(j+1)),yeuler(j-4+5*2^j:j-4+5*2^(j+1)))
    hold on
 
end
%heun
       figure(2)
    plot(time(1:6),yheun(1:6))
    hold on
for j=1:m-1;
    figure(2)
    plot(time(j-4+5*2^j:j-4+5*2^(j+1)),yheun(j-4+5*2^j:j-4+5*2^(j+1)))
    hold on
 
end
%runge
       figure(3)
    plot(time(1:6,1),yrunge(1:6))
    hold on
for j=1:m-1;
    figure(3)
    plot(time(j-4+5*2^j:j-4+5*2^(j+1)),yrunge(j-4+5*2^j:j-4+5*2^(j+1)))
    hold on
 
end



%Errors compared to exact
b=zeros(m,1);
%euler error
Eeuler=zeros(m,1);

b(1)=sum((yeuler(2:6)-exact(time(2:6))).^2)

Eeuler(1)=sqrt(b(1)/tend);
for j=1:m-1
    a(j+1)=sum((yeuler(j-3+5*2^j:j-4+5*2^(j+1))-exact(time(j-3+5*2^j:j-4+5*2^(j+1)))).^2)
    Eeuler(j+1)=sqrt((a(j+1))*((1/2)^j)/tend)
end
Eeuler

%%%% Heun error
Eheun=zeros(m,1);
a(1)=sum((yheun(2:6)-exact(time(2:6))).^2);
Eheun(1)=sqrt(a(1)/tend);
for j=1:m-1
    a(j+1)=sum((yheun(j-3+5*2^j:j-4+5*2^(j+1))-exact(time(j-3+5*2^j:j-4+5*2^(j+1)))).^2);
    Eheun(j+1)=sqrt(((1/2)^j)*(a(j+1))/tend);
end
Eheun


%Runge Kutta error
Erunge=zeros(m,1);
a(1)=sum((yrunge(2:6)-exact(time(2:6))).^2);
Erunge(1)=sqrt(a(1)/tend);
for j=1:m-1
    a(j+1)=sum((yrunge(j-3+5*2^j:j-4+5*2^(j+1))-exact(time(j-3+5*2^j:j-4+5*2^(j+1)))).^2);
    Erunge(j+1)=sqrt(((1/2)^j)*(a(j+1))/tend);
end
Erunge


%Errors compared to best

%euler error
Eeulerb=zeros(m-1,1);
a(1)=sum((yeuler(2:6)-yrunge(m-4+5*2^(m-1):8:m-5+5*2^(m))).^2);
Eeulerb(1)=sqrt(a(1)/tend);
for j=1:m-2
  
    a(j+1)=sum((yeuler(j-3+5*2^j:j-4+5*2^(j+1))-yrunge(m-4+5*2^(m-1):2^(m-j-1):m-5+5*2^(m))).^2);
    Eeulerb(j+1)=sqrt(((1/2)^j)*a(j+1)/tend);
end
Eeulerb


%heun error
Eheunb=zeros(m-1,1);
a(1)=sum((yheun(2:6)-yrunge(m-4+5*2^(m-1):8:m-5+5*2^(m))).^2);
Eheunb(1)=sqrt(a(1)/tend);
for j=1:m-2
  
    a(j+1)=sum((yheun(j-3+5*2^j:j-4+5*2^(j+1))-yrunge(m-4+5*2^(m-1):2^(m-j-1):m-5+5*2^(m))).^2);
    Eheunb(j+1)=sqrt(((1/2)^j)*a(j+1)/tend);
end
Eheunb


%runge kutta error
Erungeb=zeros(m-1,1);
a(1)=sum((yrunge(2:6)-yrunge(m-4+5*2^(m-1):8:m-5+5*2^(m))).^2);
Erungeb(1)=sqrt(a(1)/tend);
for j=1:m-2
  
    a(j+1)=sum((yrunge(j-3+5*2^j:j-4+5*2^(j+1))-yrunge(m-4+5*2^(m-1):2^(m-j-1):m-5+5*2^(m))).^2);
    Erungeb(j+1)=sqrt(((1/2)^j)*a(j+1)/tend);
end
Erungeb

ratio=zeros(3,3);
%question D Euler
for j=1:3
    ratio(j,1)=Eeuler(j)/Eeuler(j+1);
end
%question D heun
for j=1:3
    ratio(j,2)=Eheun(j)/Eheun(j+1);
end

%question D runge
for j=1:3
    ratio(j,3)=Erunge(j)/Erunge(j+1);
end
ratio

function g = differential(y)
g=(1-y./10).*y;
end

function f = exact(t)
f=10./(1+9*exp(-t));
end

