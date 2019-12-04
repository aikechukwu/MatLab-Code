% Algorithm for serial computing

clc;
clear;
close all;

%% Problem Definition

tic

CostFunction=@(x) ZDT(x);

data;

nVar=10;             % Number of Decision Variables

VarSize=[nVar 1];   % Decision Variables Matrix Size

VarMin=ones(1,10);           % Decision Variables Lower Bound
VarMax=ss;           % Decision Variables Upper Bound

%% SPEA2 Settings

MaxIt=50;          % Maximum Number of Iterations

nPop=500;            % Population Size

nArchive=500;        % Archive Size

K=round(sqrt(nPop+nArchive));  % KNN Parameter

pCrossover=0.7;
nCrossover=round(pCrossover*nPop/2)*2;

pMutation=1-pCrossover;
nMutation=nPop-nCrossover;

crossover_params.gamma=0.1;
crossover_params.VarMin=VarMin;
crossover_params.VarMax=VarMax;

mutation_params.h=0.2;
mutation_params.VarMin=VarMin;
mutation_params.VarMax=VarMax;

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.S=[];
empty_individual.R=[];
empty_individual.sigma=[];
empty_individual.sigmaK=[];
empty_individual.D=[];
empty_individual.F=[];
empty_individual.G=[];

pop=repmat(empty_individual,nPop,1);
for i=1:nPop
    pop(i).Position=[];
    
    for mm = 1:nVar
    pop(i).Position=[pop(i).Position randi(VarMax(mm),1)];
    end
    pop(i).Cost=CostFunction(pop(i).Position);
end

archive=[];

%% Main Loop

for it=1:MaxIt
    
    Q=[pop
       archive];
    
    nQ=numel(Q);
    
    dom=false(nQ,nQ);
    
    for i=1:nQ
        Q(i).S=0;
    end  
    for i=1:nQ
        for j=i+1:nQ
            
            if Dominates(Q(i),Q(j))
                Q(i).S=Q(i).S+1;
                dom(i,j)=true;
                
            elseif Dominates(Q(j),Q(i))
                Q(j).S=Q(j).S+1;
                dom(j,i)=true;
            end
            
        end
    end
    
    S=[Q.S];
    for i=1:nQ
        Q(i).R=sum(S(dom(:,i)));
    end
    
    Z=[Q.Cost]';
    SIGMA=pdist2(Z,Z,'seuclidean');
    SIGMA=sort(SIGMA);
    for i=1:nQ
        Q(i).sigma=SIGMA(:,i);
        Q(i).sigmaK=Q(i).sigma(K);
        Q(i).D=1/(Q(i).sigmaK+2);
        Q(i).F=Q(i).R+Q(i).D;
    end
    
    nND=sum([Q.R]==0);
    if nND<=nArchive
        F=[Q.F];
        [F, SO]=sort(F);
        Q=Q(SO);
        archive=Q(1:min(nArchive,nQ));
        
    else
        SIGMA=SIGMA(:,[Q.R]==0);
        archive=Q([Q.R]==0);
        
        k=2;
        while numel(archive)>nArchive
            while min(SIGMA(k,:))==max(SIGMA(k,:)) && k<size(SIGMA,1)
                k=k+1;
            end
            
            [~, j]=min(SIGMA(k,:));
            
            archive(j)=[];
            SIGMA(:,j)=[];
        end
        
    end
    
    for uu = 1:nArchive
    aa = isempty(archive(uu).G);
    if aa==1
        archive(uu).G = it;
    end
    end
    

    PF=archive([archive.R]==0); % Approximate Pareto Front
    
    % Plot Pareto Front
    figure(1);
    PlotCosts(PF);
    pause(0.01);
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Number of PF members = ' num2str(numel(PF))]);
         
  
    if it>=MaxIt
        break;
    end
    
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    gamma = crossover_params.gamma;
    popc1 = popc;
    popc2 = popc;
        
    for c=1:nCrossover/2
        
        p1=BinaryTournamentSelection(archive,[archive.F]);
        p2=BinaryTournamentSelection(archive,[archive.F]);
        
        alpha1=unifrnd(-gamma,1+gamma,size(p1.Position));
        
        x1= p1.Position;
        x2= p2.Position;
        params = crossover_params;
        
        VarMin1=params.VarMin;
        VarMax1=params.VarMax;
        
        y1=round(alpha1.*x1+(1-alpha1).*x2);
        y1=min(max(y1,VarMin1),VarMax1);
        
        y2=round(alpha1.*x2+(1-alpha1).*x1);
        y2=min(max(y2,VarMin1),VarMax1);
    
        popc1(c).Position=y1;
        popc2(c).Position=y2;
        
        popc1(c).Cost=CostFunction(popc1(c).Position);
        popc2(c).Cost=CostFunction(popc2(c).Position);
        
    end
    pp = [popc1;popc2];
    
    popc = popc(:);
   
    for tt = 1:numel(popc)
        popc(tt).Position=pp(tt).Position;
        popc(tt).Cost=pp(tt).Cost;
    end
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    for m=1:nMutation
        
        p=BinaryTournamentSelection(archive,[archive.F]);
        
        xxx = p.Position;
        params = mutation_params;
        h=params.h;
        VarMin2=params.VarMin;
        VarMax2=params.VarMax;

        sigma=h*(VarMax-VarMin);
        xx = randn(size(xxx));
        yy = round(xxx + sigma.* xx);
        popm(m).Position = min(max(yy,VarMin),VarMax);
        
        popm(m).Cost=CostFunction(popm(m).Position);
        
    end
    
    % Create New Population
    pop=[popc
         popm];
    
end

%% Results
PFC = [PF.Cost];
for j=1:size(PFC,1)
    disp(['Objective #' num2str(j) ':']);
    disp(['      Min = ' num2str(min(PFC(j,:)))]);
    disp(['      Max = ' num2str(max(PFC(j,:)))]);
    disp(['    Range = ' num2str(max(PFC(j,:))-min(PFC(j,:)))]);
    disp(['    St.D. = ' num2str(std(PFC(j,:)))]);
    disp(['     Mean = ' num2str(mean(PFC(j,:)))]);
    disp(' ');
end

STable;

toc
delete(gcp('nocreate'))