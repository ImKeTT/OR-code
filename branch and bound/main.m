% main.m
% ?????
% -----------------------------------------------
% Model to be solved?
% min z = f * x
% A * x <= b
% x >= 0, and x is an integer
% ---------------------------------------------------
clear global;
clear;
clc;

global result; % store all the integer solution
global lowerBound; % ??
global upperBound; % ??
global count; % To determine whether it is the first branch

count = 1;

f = [-40, -90];
A = [8, 7;
    7, 20;];
b = [56; 70];
Aeq = [];
beq = [];
lbnd = [0; 0];
ubnd = [inf; inf];

BinTree = createBinTreeNode({f, A, b, Aeq, beq, lbnd, ubnd});
if ~isempty(result)
    [fval,flag]=min(result(:,end)); % Each row in result corresponds to an integer solution and its corresponding function value
    Result=result(flag,:);
    disp('the best solution to this IP is:');
    disp(Result(1,1:end-1));
    disp('the best solution to this IP is:');
    disp(Result(1,end));
else
    disp('No feasible solution');
end

