function [Y,Xf,Af] = HVAC_1(X,Xi,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 31-Aug-2017 17:45:00.
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
x1_step1.gain = [0.821432825277131;0.0714285714285714;0.25];
x1_step1.ymin = -1;

% Input 2
x2_step1.xoffset = 71;
x2_step1.gain = 0.25;
x2_step1.ymin = -1;

% Layer 1
b1 = [-1.9782662482592888;-1.7571114861624197;-0.94668876003239988;-1.3938235098106326;0.10251399840844035;-0.58717999833734602;0.91797179669974416;1.1027507410252342;2.0226341721170153;2.0674830258716201];
IW1_1 = [1.0996640908434565 0.52848780774134729 1.9801291268912924;0.076609053779325198 1.7626728222580639 0.13436146190535808;0.085295684018378615 1.3730637436593778 0.38231640161859742;0.016427726005705856 0.8763809288889608 -1.9558910893829193;-0.35432096873359181 1.0195172412874158 1.8763808595680462;-0.51011089613735128 -1.0450412061371464 1.58411280439238;1.7285197166001705 0.96084401029717148 1.4041676501485201;-0.28422491507016823 2.0306848606222454 -1.3020363349021715;0.43262120912220048 2.0261855580678478 -0.28197909976573782;0.98555854246190289 -0.56698801201770999 1.7159387085059092];
IW1_2 = [1.3479208065707828;1.3333168646847446;-1.2449887828879591;-1.3196459891789285;-0.34506792077768483;-2.0143401878717442;2.6413086664664869;-0.4823640086611452;1.207289611767371;-0.69113171673129936];

% Layer 2
b2 = -0.61569674317792522;
LW2_1 = [-0.41704861837696916 0.44418496341736635 -0.68097111323997539 0.30626254017210358 0.74973997856921804 -0.59068413051788615 -0.15087162504966184 -0.18775476869379401 0.0073074634561239027 0.066733943870624882];

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