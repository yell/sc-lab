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
E=Euler(1,5);
toc


tic 
H=Heun(1,5); 
toc


tic 
R=RungeKutta(1,5); 
toc



%Question 2 part C
%matrix "Errors" is a matrix
%Column headers are time increments
%Rows are RMS errors for each method Euler Heun and RK4 in that order

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



%this function takes a function handle
%iteratues though the funcctions calculating the
%errors at time steps 1 1/2 1/4  and 1/8
%then using the time step of 1/8 as the exact solution calculates
%the esitmated error


t_inc=@(t)(1./2.^t);
C ={ @Euler @Heun @RungeKutta };

for i=1:3,  %iterate over the functions
    for j=3:-1:0;
 for time = t_inc([j])   %iterate over the time elements starting from 1/8
  A = C{i}(time,5);  %evaluate method with best time t=1/8
if j==3
    estimate = A;  %store fine mesh (t=1/8) matrix as a lookup table
    global_error_estimate(i,j)= err (A) %Fetch the errors t=1/8
else
    %TODO get errors uing matrix estimate as the benchmark
end
end
    end
end



function A = Euler( dt, tEnd )
%our implementation of the Euler method.
% ** two additional columns added after computed solution ***
%the second column is the exact solution 
%and the thrid column is the corresponding time point

global pop dpdt
t=0:dt:tEnd-dt;
A=zeros((length(t)),3);     %Initialise matrix
A(1,1) = 1;                   %Initial Population

for i=1:(length(t))
    A(i+1,1)= A(i,1) + dt * dpdt( A(i,1) );    
end
   A(:,2)= pop( 0:dt:dt*(length(t)) );   %analytic solution on second column
   A(:,3)= 0:dt:dt*(length(t));         %time from t=0 on third column.
   A = A(2:end,:);                      %delete the initial conditions
end


function A = Heun( dt, tEnd )
global pop dpdt
t=0:dt:tEnd-dt;
A=zeros((length(t)),3);
A(1,1) = 1; %Initial Population

for i=1:(length(t))
    k1 = dpdt( A(i,1) );
    p1 = A(i,1) + k1 * dt;
    k2 = dpdt( p1 );
    A(i+1,1)= A(i,1) + dt/2 * ( k1 + k2 );    
end

   A(:,2)= pop( 0:dt:dt*(length(t)) );  
   A(:,3)= 0:dt:dt*(length(t)); 
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
   A(:,3)= 0:dt:dt*(length(t)); 
   A = A(2:end,:);              
end

function e = err( A ) 
%This function calculates the exact error
%between the gradient method computation and
%the exact analytic solution.
%input matrix has 2 columns, Frist column is gradient approximation 
%and second is the exact anaytic solution
global pop
S=0; %sum of dif squared
for i=1:size(A,1)
    S = S + ( A(i,1) - A(i,2) )^2;
end
e = sqrt( 1/size(A,1) * S );

end



