function h = ray_model_cor(h_b,cor,d)
% generate a exponential rayleigh model that is correlated to other
% Raymodel
% inputs:
%       d: the distance between two objects
%       cor: correlation coefficient（两个信道的相关性）
%       h_b: the base Rayleigh channel model
% output:
%       h: the exponential Rayleigh model correlated to channel h
lamda = 3;

h_cg = 5*d^(-lamda/2);

pow_h = exp(-(0:length(h_b)-1));
pow_h = h_cg*pow_h/norm(pow_h); %norm(pow_h)返回向量的模或欧几里得长度

h = cor*h_b + sqrt(1-cor^2).*sqrt(pow_h').* (randn(length(h_b),1) + 1i*randn(length(h_b),1));