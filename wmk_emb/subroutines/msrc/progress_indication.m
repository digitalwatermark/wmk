
% % Indicate and display the progress of repeated process
% % Peng Zhang     Tsinghua Univ.    2008.10.01
% % % % % % % % % % % % % % % % % % % % % % % 
% Prototype:
% function varargout = progress_indication(varargin)
% 
%--------------------------------------------------------------------------

function varargout = progress_indication(varargin)

if nargout==1
    varargout{1} = waitbar(0, [varargin{1},' 0%']);
elseif nargout==0
    var_rept = varargin{1};
    if ischar(var_rept)
        fprintf([varargin{1},':  0%%']);
    elseif nargin==5                       
%         var_rept = varargin{1};
        max_times = varargin{2};
        step = varargin{3};
        
        if ~mod(var_rept, step)
            h = varargin{4};
            str = varargin{5};
            percent = var_rept/max_times;
            waitbar(percent, h, [str, ' ', num2str(floor(percent*100)), '%']);
        end
        if (var_rept==max_times)
            h = varargin{4};
            str = varargin{5};
            waitbar(1, h, [str, ' 100%']);
%             pause(1)
            close(h);
%             fprintf('\nSimulation Completed.\n');
        end
    elseif nargin==3                      
%         var_rept = varargin{1};
        max_times = varargin{2};
        step = varargin{3};

        if ~rem(var_rept, step)
            fprintf('\b\b\b\b%3.0f%%', var_rept/max_times*100);  
        end
        if (var_rept==max_times)
            fprintf('\b\b\b\b%3.0f%%\n', 100);
        end
    end
else
    error('Too many output arguments.');
end
