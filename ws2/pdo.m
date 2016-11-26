%Solutions to Exercise sheet 2 

clc
clear
global pop dpdt
%Global Function Handles
format long;
pop=@(t)(10./(1+9.*exp(-t)));
dpdt=@(pa)((1-pa/10).*pa);



% Solution to Exercise 1

t = [0:.1:6];
hold on;
grid on;
plot(t,pop(t))

%Question 2 part B

%Preciction functions A = Function( deltaT, TimeEnd )
%Function returns computed and exact values

tic 
E=Euler(1,5)
toc


tic 
H=Heun(1,5); 
toc


tic 
R=RungeKutta(1,5); 
toc



%Question 2 part C
%matrix "Errors" is a matrix with header row time increments 
% Subsequent rows are RMS errors for each method Euler Heun and RK4

for n=1:4
    j=1/2^(n-1);
    Errors(1,n) = j;
Errors(2,n) = err( Euler(j,5) ); 
Errors(3,n) = err( Heun(j,5) );
Errors(4,n) = err( RungeKutta(j,5) );
end

Errors

%Question 2 part D
FactorImprovement=zeros(3,3);
for j=1:3
    for i=1:3
    FactorImprovement(i,j) = Errors(i+1,j)/Errors(i+1,j+1);
    end
end
FactorImprovement

%Question 2 part E Error Factor without Analytic Solution.
% ErrorEst is a matrix with header row time increments 
% Subsequent rows are RMS errors for each method Euler Heun and RK4

for n=1:4
    j=1/2^(n-1);
ErrorsEstimate(1,n) = j;
ErrorsEstimate(2,n) = errEst( Euler(j,5) ); 
ErrorsEstimate(3,n) = errEst( Heun(j,5) );
ErrorsEstimate(4,n) = errEst( RungeKutta(j,5) );
end
ErrorsEstimate


Estimated_Factor_Improvement=zeros(3,3);
for j=1:3
    for i=1:3
    Estimated_Factor_Improvement(i,j) = ErrorsEstimate(i+1,j)/ErrorsEstimate(i+1,j+1);
    end
end
Estimated_Factor_Improvement






function A = Euler( dt, tEnd )
global pop dpdt
t=0:dt:tEnd-dt;
A=zeros((length(t)),2);     %Initialise matrix
A(1,1) = 1;                   %Initial Population

for i=1:(length(t))
    A(i+1,1)= A(i,1) + dt * dpdt( A(i,1) );    
end
   A(:,2)= pop( 0:dt:dt*(length(t)) );   %analytic solution on second column
   A = A(2:end,:);                      %delete the initial conditions
end


function A = Heun( dt, tEnd )
global pop dpdt
t=0:dt:tEnd-dt;
A=zeros((length(t)),2);
A(1,1) = 1; %Initial Population

for i=1:(length(t))
    k1 = dpdt( A(i,1) );
    p1 = A(i,1) + k1 * dt;
    k2 = dpdt( p1 );
    A(i+1,1)= A(i,1) + dt/2 * ( k1 + k2 );    
end
   A(:,2)= pop( 0:dt:dt*(length(t)) );   
   A = A(2:end,:);            
end


function A = RungeKutta( dt, tEnd )
global pop dpdt
t=0:dt:tEnd-dt;
A=zeros((length(t)),2);
A(1,1) = 1; %Initial Population

for i=1:(length(t))
    k1 = dpdt( A(i,1) );
    p1 = A(i,1) + k1 * dt/2;
    k2 = dpdt( p1 );
    p2 = A(i,1) + k2 * dt/2;
    k3 = dpdt ( p2 );
    p3 = A(i,1) + k3*dt;
    k4 = dpdt( p3 );
    A(i+1,1)= A(i,1) + dt/6 * ( k1 + 2*k2 + 2*k3 + k4);    
end
   A(:,2)= pop( 0:dt:dt*(length(t)) );  
   A = A(2:end,:);              
end

function e = err( A ) 
%This function calculates the exact error
%between the gradient method computation and
%the exact analytic solution.
%input matrix has 2 columns, Frist column is gradient approximation 
%and second is the 
global pop
S=0; %sum of dif squared
for i=1:size(A,1)
    S = S + ( A(i,1) - A(i,2) )^2;
end
e = sqrt( 1/size(A,1) * S );

end


function e = errEst( A ) 
%This function Isnt working.  It's supposed to calculate the 
%estimated error without th analytic solution!  :(
global pop
S=0; %sum of dif squared
for i=1:size(A,1)
    smallest_error = abs( A(end,1) - A(end-1,1) );
    S = S + ( A(i,1) - smallest_error )^2;
end
e = sqrt( 1/size(A,1) * S );

end


