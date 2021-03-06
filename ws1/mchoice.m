
function next = mchoice(ng, i, j, com1, com2)
% machine next move
global samplem2 transm2 samplem transm policy

if(ng == 1)
    % initialize matrices
    [samplem,transm] = initmchoice;
    [samplem2,transm2] = initmchoice;
    next = randi(3);
else
    samplem = updatesamplem(i,j,samplem);
    transm = updatetransm(samplem);         %human transition matrix
    samplem2 = updatesamplem(com1,com2,samplem2);
    transm2 = updatetransm(samplem2); %solution to problem d (computer transition matrix)
    switch policy
        case 1
            next = predict1(j,transm);
        case 2
            next = predict2(j,transm);
        case 3
            next = predict3(j,transm);
        otherwise
            error('Bad policy given!')
    end
    transm2
end

% --- Additional functions ---
function [SAMple,outputMAT] = initmchoice()
SAMple = [1 1 1; 1 1 1; 1 1 1];
outputMAT = updatetransm(SAMple);

function transm = updatetransm(samplem)
w = sum(samplem,2);  %check that this is in the right place 
transm = zeros(3);
for i=1:size(samplem,1)
    transm(i,:) = samplem(i,:)./w(i);
end

function samplem = updatesamplem(i,j,sample);
samplem = sample;
samplem(i,j) = sample(i,j)+1;


% --- The prediction policies ---

function next = predict1(j,transm)
transm  %display transition matrix (as right stochastic)
global param_a  param_b
z=rand;
D=[mod(j,3)+1;mod(j+1,3)+1;j];
k = sum(z>=([0,param_a,param_b,1]));
hnext=D(k);
% param_a and param_b introduce bias into the system such that:
% a&b~=1 favours mod(j,3)+1  -> computer WIN vs human mod(rno,3)+1
% a~=0 & b~=1 favours mod(j+1,3)+1  will cause computer to LOSE against mod(rno,3)+1
% a&b~=0 favours j  will cause computer to DRAW against mod(rno,3)+1
next = winchoice(hnext);

function next = predict2(j,transm)
transm % display transition matrix
[hprob,hnext] = max(transm(j,:));
next = winchoice(hnext);

function next = predict3(j,transm)
transm % display transition matrix
prob = transm(j,:);
r = rand;
hnext = sum(r>=cumsum([0,prob]));
next = winchoice(hnext);


% --- Choosing the computer next move ---

function next = winchoice(hnext)
% choose next move to win

switch hnext
    case 1 % rock
        next = 2; % paper
    case 2 % paper
        next = 3; % scissors
    case 3 % scissors
        next = 1; % rock
end