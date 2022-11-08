function [gbestX,gbestfitness,gbesthistory]= GO(popsize,dimension,xmax,xmin,MaxFEs,Func,FuncId)
%Parameter setting
FEs=0;P1=5;P2=0.001;P3=0.3;
%initialization
x=unifrnd(xmin,xmax,popsize,dimension);
gbestfitness=inf;
for i=1:popsize
    fitness(i)=Func(x(i,:)',FuncId);
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
        Worst_X = x(ind(randi([popsize-P1+1,popsize],1)),:);
        Better_X=x(ind(randi([2,P1],1)),:);
        random=selectID(popsize,i,2);
        L1=random(1);
        L2=random(2);
        Gap1=(Best_X-Better_X);
        Gap2=(Best_X-Worst_X);
        Gap3=(Better_X-Worst_X);
        Gap4=(x(L1,:)-x(L2,:));
        Distance1=norm(Gap1);
        Distance2=norm(Gap2);
        Distance3=norm(Gap3);
        Distance4=norm(Gap4);
        SumDistance=Distance1+Distance2+Distance3+Distance4;
        LF1=Distance1/SumDistance;
        LF2=Distance2/SumDistance;
        LF3=Distance3/SumDistance;
        LF4=Distance4/SumDistance;
        SF=(fitness(i)/max(fitness));
        KA1=LF1*SF*Gap1;
        KA2=LF2*SF*Gap2;
        KA3=LF3*SF*Gap3;
        KA4=LF4*SF*Gap4;
        newx(i,:)=x(i,:)+KA1+KA2+KA3+KA4;
        %Clipping
        newx(i,:)=max(newx(i,:),xmin);
        newx(i,:)=min(newx(i,:),xmax);
        newfitness=Func(newx(i,:)',FuncId);
        FEs=FEs+1;
        %Update
        if fitness(i)>newfitness
            fitness(i)=newfitness;
            x(i,:)=newx(i,:);
        else
            if rand<P2&&ind(i)~=1
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
            if rand<P3
                R=x(ind(randi(P1)),:);
                newx(i,j) = x(i,j)+(R(:,j)-x(i,j))*unifrnd(0,1);
                AF=(0.01+(0.1-0.01)*(1-FEs/MaxFEs));
                if rand<AF
                    newx(i,j)=xmin+(xmax-xmin)*unifrnd(0,1);
                end
            end
            j=j+1;
        end
        %Clipping
        newx(i,:)=max(newx(i,:),xmin);
        newx(i,:)=min(newx(i,:),xmax);
        newfitness=Func(newx(i,:)',FuncId);
        FEs=FEs+1;
        %Update
        if fitness(i)>newfitness
            fitness(i)=newfitness;
            x(i,:)=newx(i,:);
        else
            if rand<P2&&ind(i)~=1
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
end

function [r]=selectID(popsize,i,k)
%Generate k random integer values within [1,popsize] that do not include i and do not repeat each other
if k<= popsize
    vecc=[1:i-1,i+1:popsize];
    r=zeros(1,k);
    for kkk =1:k
        n = popsize-kkk;
        t = randi(n,1,1);
        r(kkk) = vecc(t);
        vecc(t)=[];
    end
end
end

