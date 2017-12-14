% % EAQUAL
% % Zhang Peng    Tsinghua Univ.    2009.01.05
% % % % % % % % % % % % % % % % % % % 
% Prototype:
% function y = EAQUAL(varargin)
% 
% ---------------------------------------------------------------

function y = EAQUAL(varargin)

if nargin<2 || nargin>3
    error('Unsupported number of input arguments') 
end

ref_file = varargin{1};          
test_file = varargin{2};        

if nargin<3
	option = [];
else
    option = varargin{3};       
end

[pathstr, name, ext, versn] = fileparts(which('EAQUAL.exe'));           

temp_file = fullfile(pathstr,'temp_eaqualreport.txt');           

dos([pathstr,'\EAQUAL ', option, ' -silent ', temp_file, ' -fref ', ref_file, ' -ftest ', test_file]);   % execute EAQUAL

fid = fopen(temp_file);                                               

filecontent = textscan(fid,'%s','delimiter', '\n');         
lines = filecontent{1};                                                

line2 =  textscan(lines{2},'%s','delimiter', '\t');          
line3 =  textscan(lines{3},'%s','delimiter', '\t');         

% line3 = dlmread('b.txt','\t',2,0);            

metrics = line2{1}; 
values = line3{1};  

for ii=1:length(values)
    values{ii} = str2double(values{ii});    
end

y = cell2struct(values, metrics, 1);   

fclose(fid);
delete(temp_file);

return