function [Y,Xf,Af] = HVAC_2(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 08-Sep-2017 17:00:24.
%
% [Y,Xf,Af] = myNeuralNetworkFunction(X,Xi,~) takes these arguments:
%
%   X = 2xTS cell, 2 inputs over TS timesteps
%   Each X{1,ts} = 3xQ matrix, input #1 at timestep ts.
%   Each X{2,ts} = 1xQ matrix, input #2 at timestep ts.
%
%   Xi = 2x1 cell 2, initial 1 input delay states.
%   Each Xi{1,ts} = 3xQ matrix, initial states for input #1.
%   Each Xi{2,ts} = 1xQ matrix, initial states for input #2.
%
%   Ai = 2x0 cell 2, initial 1 layer delay states.
%   Each Ai{1,ts} = 10xQ matrix, initial states for layer #1.
%   Each Ai{2,ts} = 1xQ matrix, initial states for layer #2.
%
% and returns:
%   Y = 1xTS cell of 2 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
%
%   Xf = 2x1 cell 2, final 1 input delay states.
%   Each Xf{1,ts} = 3xQ matrix, final states for input #1.
%   Each Xf{2,ts} = 1xQ matrix, final states for input #2.
%
%   Af = 2x0 cell 2, final 0 layer delay states.
%   Each Af{1ts} = 10xQ matrix, final states for layer #1.
%   Each Af{2ts} = 1xQ matrix, final states for layer #2.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0;57;71];
x1_step1.gain = [0.783116018638161;0.0714285714285714;0.25];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = 71;
x2_step1.gain = 0.25;
x2_step1.ymin = -1;

% Layer 1
b1 = [2.1212260150774425;2.0234010456684293;-1.644063395069761;-0.34945372642532896;-1.049276207412918;0.15126728801501466;-0.016504162184649507;1.6950523504313071;-3.2351630805529545;-2.6990060568172112];
IW1_1 = [-0.11261914183388352 -1.34411744651426 -1.9192267377030694;-0.94110489658660001 -0.83788131283915657 -0.88822794931606674;0.5047981043755474 0.57277466051572989 0.46432093764355764;-0.009524056800641223 1.454705219960803 -1.2233184597468063;0.38685204522922889 -2.4926959174279286 -0.14810258775528123;-1.7447446498047787 1.7542054295918228 0.9906488106468132;-1.4928695978189268 0.74216337758286066 0.78515209940528252;2.2289988863559369 -0.69112886808243279 -0.97474812795028065;-0.69350601966843439 -1.1454251182715538 -0.63028540927431309;-0.79730387341758613 1.4680578980247254 2.3284075240046263];
IW1_2 = [-0.57360251233562021;-1.7045262852609171;-2.141794915762723;2.1580665921542783;0.46731268487842026;-0.91931507502235732;1.2630653714016942;-1.053048101653913;-1.3863141277160289;-0.32306937542682368];

% Layer 2
b2 = -0.81389677574415809;
LW2_1 = [-0.73330771291176222 0.47931939205446905 -0.39690684483037325 0.46141073021183249 -0.051070487703303545 -0.211390092883317 -0.082660536146202737 -0.45526027610139408 -0.23250130779001835 -0.75380602240011241];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.25;
y1_step1.xoffset = 71;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX, X = {X}; end;
if (nargin < 2), error('Initial input states Xi argument needed.'); end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},2); % samples/series
elseif ~isempty(Xi)
    Q = size(Xi{1},2);
else
    Q = 0;
end

% Input 1 Delay States
Xd1 = cell(1,2);
for ts=1:1
    Xd1{ts} = mapminmax_apply(Xi{1,ts},x1_step1);
end

% Input 2 Delay States
Xd2 = cell(1,2);
for ts=1:1
    Xd2{ts} = mapminmax_apply(Xi{2,ts},x2_step1);
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Rotating delay state position
    xdts = mod(ts+0,2)+1;
    
    % Input 1
    Xd1{xdts} = mapminmax_apply(X{1,ts},x1_step1);
    
    % Input 2
    Xd2{xdts} = mapminmax_apply(X{2,ts},x2_step1);
    
    % Layer 1
    tapdelay1 = cat(1,Xd1{mod(xdts-1-1,2)+1});
    tapdelay2 = cat(1,Xd2{mod(xdts-1-1,2)+1});
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*tapdelay1 + IW1_2*tapdelay2);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
end

% Final Delay States
finalxts = TS+(1: 1);
xits = finalxts(finalxts<=1);
xts = finalxts(finalxts>1)-1;
Xf = [Xi(:,xits) X(:,xts)];
Af = cell(2,0);

% Format Output Arguments
if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end