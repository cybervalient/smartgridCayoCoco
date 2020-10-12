function [xmin,fmin] = edaC(net,Aeq,Beq,neq,Aieq,Bieq,nieq,lb,ub,nvars,NP,I_itermax)
BRM=2;
numParents=10;
pop=genpop(lb,ub,NP); 
eq = 0;
ieq = 0;
for i=1:NP
     S_val(i)= objfunc(pop(i,:),net);
     if neq>0
      eq =(neq-sum((pop(i,:)* Aeq')' == Beq));  
     end
     if ieq > 0
      ieq =(nieq-sum((pop(i,:)*Aieq')'<=Bieq));
     end   
     S_val(i) = S_val(i) + (eq+ieq)*100000000;
end
 S_V = S_val';
 fitness = sortrows([ (1:NP)' S_V(:, 1) ], 2);
%% Selection 
idx = fitness(1:numParents, 1);
parent = pop(idx,:);
fmin = fitness(1,2);
xmin = parent(1,:);
gen=1;
while gen<I_itermax
  %% Learning
  FM_ui =  learningEDA(parent,NP);    
  %% Boundary Control
  for i=1:NP
   FM_ui(i,:) = update_eda(FM_ui(i,:)',lb,ub,BRM);
  end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %% Evaluation 
 for i=1:NP
    S_val(i)= objfunc(FM_ui(i,:),net);
     if neq>0
      eq =(neq-sum((FM_ui(i,:)* Aeq')' == Beq));  
     end
     if ieq > 0
      ieq =(nieq-sum((FM_ui(i,:)*Aieq')'<=Bieq));
     end   
     S_val(i) = S_val(i) + (eq+ieq)*100000000;
 end
 S_V = S_val';
 fitness = sortrows([ (1:NP)' S_V(:, 1) ], 2);
 
 pop = FM_ui;
 
 %% parents selection 
  idx = fitness(1:numParents, 1);
  parent = pop(idx,:);
  
  f = mean(fitness(1:numParents,2));
  x = mean(parent); 
   
  if f < fmin
    xmin = x;
    fmin = f;
  end
  
  gen=gen+1; 
  
end
xmin = update_eda(xmin',lb,ub,BRM);
end

function pop=genpop(lb,ub,NP)
 for i=1:NP 
  pop(i,:)= lb' + (ub'-lb').*rand(1,1); 
 end
end

 function p=update_eda(p,lowMatrix,upMatrix,BRM)
  switch BRM
    case 1 % max and min replace
        [idx] = find(p<lowMatrix);
        p(idx)=lowMatrix(idx);
        [idx] = find(p>upMatrix);
        p(idx)=upMatrix(idx);
    case 2 %Random reinitialization
        [idx] = [find(p<lowMatrix);find(p>upMatrix)];
        replace=unifrnd(lowMatrix(idx),upMatrix(idx),length(idx),1);
        p(idx)=replace;
    case 3 %Bounce Back
        [idx] = find(p<lowMatrix);
      p(idx)=unifrnd(lowMatrix(idx),p(idx),length(idx),1);
        [idx] = find(p>upMatrix);
      p(idx)=unifrnd(p(idx), upMatrix(idx),length(idx),1);
   end
 end

function pop_eda = learningEDA(pop_u,I_NP)
 %Cauchy's distribution
  mu = mean(pop_u);
  sd = std(pop_u);
for i=1:I_NP
 pop_eda(i,:) =  normrnd(mu,sd).*(mu - sd*tan(pi*(rand(1,1))-0.5));
end
end