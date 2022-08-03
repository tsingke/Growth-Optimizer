# Growth-Optimizer
a novel and powerful meta-heuristic algorithm

# Growth-Optimizer Source Code

```MATLAB
% Growth Optimizer: A powerful metaheuristic algorithm for solving different optimization problems
function [gbestX,gbestfitness,gbesthistory]= GO(popsize,dimension,xmax,xmin,MaxFEs,Func,FuncId)
FEs=0;
Fitness=Func;
x=xmin+(xmax-xmin)*unifrnd(0,1,popsize,dimension);
gbestfitness=inf;
for i=1:popsize
    fitness(i)=Fitness(x(i,:)',FuncId);
    FEs=FEs+1;
    if gbestfitness>fitness(i)
        gbestfitness=fitness(i);
        gbestX=x(i,:);
    end
    gbesthistory(FEs)=gbestfitness;
    fprintf("FEs: %d, fitness error: %e\n",FEs,gbestfitness);
end
while 1
    [~, ind]=sort(fitness);
    Best_X=x(ind(1),:);
%% Learning phase
    for i=1:popsize
        Worst_X = x(ind(randi([popsize-4,popsize])),:);
        Better_X=x(ind(randi([2,5])),:);
        random=selectID(popsize,i,2);
        L1=random(1);
        L2=random(2);
        D_value1=(Best_X-Better_X);
        D_value2=(Best_X-Worst_X);
        D_value3=(Better_X-Worst_X);
        D_value4=(x(L1,:)-x(L2,:));
        Distance1=norm(D_value1);
        Distance2=norm(D_value2);
        Distance3=norm(D_value3);
        Distance4=norm(D_value4);
        rate=Distance1+Distance2+Distance3+Distance4;
        LF1=Distance1/rate;
        LF2=Distance2/rate;
        LF3=Distance3/rate;
        LF4=Distance4/rate;
        SF=(fitness(i)/max(fitness));
        Gap1=LF1*SF*D_value1;
        Gap2=LF2*SF*D_value2;
        Gap3=LF3*SF*D_value3;
        Gap4=LF4*SF*D_value4;
        newx(i,:)=x(i,:)+Gap1+Gap2+Gap3+Gap4;
        %Clipping
        newx(i,:)=max(newx(i,:),xmin);
        newx(i,:)=min(newx(i,:),xmax);
        newfitness=Fitness(newx(i,:)',FuncId);
        FEs=FEs+1;
        %Update
        if fitness(i)>newfitness
            fitness(i)=newfitness;
            x(i,:)=newx(i,:);
        else
            if rand<0.001&&ind(i)~=1
                fitness(i)=newfitness;
                x(i,:)=newx(i,:);
            end
        end
        if gbestfitness>fitness(i)
            gbestfitness=fitness(i);
            gbestX=x(i,:);
        end
        gbesthistory(FEs)=gbestfitness;
        fprintf("FEs: %d, fitness error: %e\n",FEs,gbestfitness);
    end
    if FEs>=MaxFEs
        break;
    end
%% Reflection phase
    for i=1:popsize
        newx(i,:)=x(i,:);
        j=1;
        while j<=dimension
            if rand<0.3
                R=x(ind(randi(5)),:);
                newx(i,j) = x(i,j)+(R(:,j)-x(i,j))*unifrnd(0,1);
                if rand<(0.01+(0.1-0.01)*(1-FEs/MaxFEs))
                    newx(i,j)=xmin+(xmax-xmin)*unifrnd(0,1);
                end
            end
            j=j+1;
        end
        %Clipping
        newx(i,:)=max(newx(i,:),xmin);
        newx(i,:)=min(newx(i,:),xmax);
        newfitness=Fitness(newx(i,:)',FuncId);
        FEs=FEs+1;
        %Update
        if fitness(i)>newfitness
            fitness(i)=newfitness;
            x(i,:)=newx(i,:);
        else
            if rand<0.001&&ind(i)~=1
                fitness(i)=newfitness;
                x(i,:)=newx(i,:);
            end
        end
        if gbestfitness>fitness(i)
            gbestfitness=fitness(i);
            gbestX=x(i,:);
        end
        gbesthistory(FEs)=gbestfitness;
        fprintf("FEs: %d, fitness error: %e\n",FEs,gbestfitness);
    end
    if FEs>=MaxFEs
        break;
    end
end   

%Deal with the situation of too little or too much evaluation
if FEs<MaxFEs
    gbesthistory(FEs+1:MaxFEs)=gbestfitness;
else
    if FEs>MaxFEs
        gbesthistory(MaxFEs+1:end)=[];
    end
end



```
