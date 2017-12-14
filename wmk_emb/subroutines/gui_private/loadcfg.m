% % Load configurations (global variables) from file
% % Peng Zhang    Tsinghua Univ.    2009.02.09

function loadcfg(filename)

global_var;

t = clock;
tempscript = ['tempscript', dec2base(t(1),10,4), dec2base(t(2),10,2), dec2base(t(3),10,2), ...
                   dec2base(t(4),10,2), dec2base(t(5),10,2), dec2base(round(t(6)),10,2)];
copyfile(filename, [tempscript, '.m']);      

eval(tempscript);

delete([tempscript, '.m']);

return