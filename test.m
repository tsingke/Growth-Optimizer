%-----------------------------------------------------------------
%Growth Optimizer: A powerful metaheuristic algorithm for solving different optimization problems
% School of Information Science and Engineering, Shandong Normal University, Jinan
% Corresponding author: Qingke Zhang
% Email:tsingke@sdnu.edu.cn
% Note: 1.The CEC 2017 file has been recompiled to return fitness value errors.
%       2.This version of GO uses the maximum number of evaluations (MaxFEs) as its termination criterion.
%       3.Need to load input_data_17 file for shifting, rotating, etc
%       4.Not using 1E-8 as a condition for finding the global optimal solution
%-----------------------------------------------------------------
clc;
clear;
close all;
format short e
rand('state', sum(100*clock));
%Parameter setting
xmax=100;                 %Upper bound
xmin=-100;                %Lower bound
popsize=40;               %Population size (Too large value will slow down the convergence speed)
dimension=10;             %Problem dimension (dimension=10/30/50/100)
MaxFEs=dimension*10000;   %Maximum number of evaluations MaxFEs=dimension*10000
Func=@cec17_func;         %Objective function set
FuncId=[];                %Function number

for FuncId=1:30
    fprintf("\n*******Current test function No.: F%d*******\n",FuncId);
    pause(2);
    [gbestX,gbestfitness,gbesthistory]= GO(popsize,dimension,xmax,xmin,MaxFEs,Func,FuncId);
    plot(1:MaxFEs,gbesthistory,'Linewidth',3);
    title(['F',num2str(FuncId),'  Optimization History'])
end