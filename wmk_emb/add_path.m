% config paths
%function [] = add_path()

home_path = cd;
addpath(home_path)
third_party_path = [home_path,'\third_party_tools'];


 addpath(genpath([home_path,'\subroutines']))
 addpath(genpath([home_path,'\doc']))

% embedder_path=addpath(genpath([home_path,'\realtime_embedder_v3']));
% extrator_path = addpath(genpath([home_path,'\realtime_extractor_v3']));
extrator_path = genpath([home_path,'\realtime_extractor_v3']);
% embedder_path = genpath([home_path,'\realtime_embedder_v3']);

% third party tools
addpath(genpath([third_party_path,'\EAQUAL']))
addpath(genpath([third_party_path,'\FAAC']))
addpath(genpath([third_party_path,'\NeroAAC']))
addpath(genpath([third_party_path,'\LAME']))
addpath(genpath([third_party_path,'\MPG123']))
addpath(genpath([third_party_path,'\TSM']))








