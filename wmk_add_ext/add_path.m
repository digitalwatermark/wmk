% config paths
%function [] = add_path()

home_path = cd;
addpath(home_path)
% third_party_path = [home_path,'\third_party_tools'];


 addpath(genpath([home_path,'\subroutines']))
%  addpath(genpath([home_path,'\doc']))



% third party tools
% addpath(genpath([third_party_path,'\EAQUAL']))
% addpath(genpath([third_party_path,'\FAAC']))
% addpath(genpath([third_party_path,'\NeroAAC']))
% addpath(genpath([third_party_path,'\LAME']))
% addpath(genpath([third_party_path,'\MPG123']))
% addpath(genpath([third_party_path,'\TSM']))








