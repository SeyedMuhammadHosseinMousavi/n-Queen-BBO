% Solving n-queen problem by Biogeography-Based Optimization (BBO)
% algorithm

clc;
clear;
close all;

%% Problem 
% You can number of queens, here
nQueen=16;
%------------------------------------------------------

CostFunction=@(s) CostF(s);          % Cost Function
nVar=nQueen;                         % Decision Variables
VarSize=[1 nVar];                    % Decision Variables Matrix Size
VarMin=0;                            % Lower Bound of Variables
VarMax=1;                            % Upper Bound of Variables

%% BBO Parameters
MaxIt = 200;           % Iterations
nPop = 500;            % Number of Habitats (Population Size)
KeepRate = 0.2;                   % Keep Rate
nKeep = round(KeepRate*nPop);     % Number of Kept Habitats
nNew = nPop-nKeep;                % Number of New Habitats
% Migration Rates
mu = linspace(1, 0, nPop);        % Emmigration Rates
lambda = 1-mu;                    % Immigration Rates
alpha = 0.9;
pMutation = 0.3;
sigma = 0.02*(VarMax-VarMin);
%---------------------------------------------------------------
% Empty Habitat
habitat.Position = [];
habitat.Cost = [];
habitat.Sol = [];
% Create Habitats Array
pop = repmat(habitat, nPop, 1);
% Habitats
for i = 1:nPop
pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
[pop(i).Cost pop(i).Sol] = CostFunction(pop(i).Position);
end
% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);
% Best Solution 
Final = pop(1);
% Array to Hold Best Costs
CostValue = zeros(MaxIt, 1);

%% BBO 
for it = 1:MaxIt
newpop = pop;
for i = 1:nPop
for k = 1:nVar
% Migration
if rand <= lambda(i)
% Emmigration Probabilities
EP = mu;
EP(i) = 0;
EP = EP/sum(EP);
% Select Source Habitat
j = RWS(EP);
% Migration
newpop(i).Position(k) = pop(i).Position(k) ...
+alpha*(pop(j).Position(k)-pop(i).Position(k));
end
% Mutation
if rand <= pMutation
newpop(i).Position(k) = newpop(i).Position(k)+sigma*randn;
end
end
% Apply Lower and Upper Bound Limits
newpop(i).Position = max(newpop(i).Position, VarMin);
newpop(i).Position = min(newpop(i).Position, VarMax);
% Evaluation
[newpop(i).Cost newpop(i).Sol] = CostFunction(newpop(i).Position);
end
% Sort New Population
[~, SortOrder] = sort([newpop.Cost]);
newpop = newpop(SortOrder);
% Select Next Iteration Population
pop = [pop(1:nKeep)
newpop(1:nNew)];
% Sort Population
[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder);
% Update Best Solution 
Final = pop(1);
% Store Best Cost 
CostValue(it) = Final.Cost;
% Iteration 
disp(['In Iteration Number ' num2str(it) ': BBO Best Value Is = ' num2str(CostValue(it))]);
% Plot Best Solution
figure(1);
ShowRes(Final.Sol);
if CostValue(it)==0
break;
end
end

%% ITR
figure;
plot(CostValue, 'r-', 'LineWidth', 3);
xlabel('ITR');
ylabel('Cost Value');
ax = gca; 
ax.FontSize = 12; 
ax.FontWeight='bold';
set(gca,'Color','c')
grid on;

