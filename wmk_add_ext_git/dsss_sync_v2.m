% Direct Sequence Spread Spectrum (DSSS) synchronization (version 2)
% 2010-04-28

function state = dsss_sync_v2(xbuff, pn, state, param)
%fprintf('=====================dsss_sync_v2===================\n');
if (size(xbuff, 1) == 1)         % assure that xbuff, if one dimensional, has the correct orientation
    xbuff = xbuff(:);
end

% default parameters
N = length(pn);
M = 2;
csk_polar = 'bi';
default_max_acqtime = 3;
default_max_failtime = 3;
default_max_sync_jitter = 50;
%default_pfa = 1e-3;
default_pfa=0.1;

% parse specified parameter values
if nargin>=4 && isstruct(param)
    inparam_name = fieldnames(param);
    for ii=1:length(inparam_name)
        eval([inparam_name{ii}, ' = param.', inparam_name{ii}, ';']);
    end
end


State_Supported = {'INITIAL', 'ACQUISITION', 'TRACKING'};

if strcmpi(state.Sync_State, State_Supported{1})  % initialize and construnct structure 'state'
    % variables to be cleared
    Count_Acq = 0;
    Count_Fail = 0;
    Sync_Pos = NaN;
    Max_Pos = 0;
    Sink_Bit = [];
    % variables to be set to default values
    Max_Sync_Jitter = default_max_sync_jitter;
    pfa = default_pfa;
    Threshold = norminv((1-pfa)^(1/N),0,1/sqrt(N));
    Max_Acqtime = default_max_acqtime;
    Max_Failtime = default_max_failtime;
    Rxpn = [];
    Rxpn_AbsShiftAdd = [];
    Max_Rxpn_AbsShiftAdd = [];
    Sync_State = State_Supported{2};
    Next_Start_Buffer_Index = 1;
    Channel =1;
else
    Max_Acqtime = state.Max_Acqtime;
    Max_Failtime = state.Max_Failtime;
    Threshold = state.Threshold;
    Max_Sync_Jitter = state.Max_Sync_Jitter;
    Count_Acq = state.Count_Acq;
    Count_Fail = state.Count_Fail;
    
    last_sync_pos = state.Sync_Pos;
    current_start_index = state.Next_Start_Buffer_Index;
    Channel = state.Channel;
    if current_start_index<=0   
        % drop one frame for rapid sampling clock
%         current_start_index = current_start_index+N;  % affect the message sync !
        disp('Buffer underflows. Sync lost.');
        state.Count_Acq = Count_Acq;
        state.Sync_Pos = NaN;
        state.Next_Start_Buffer_Index = 1;
        Sync_State = State_Supported{2};         
    elseif current_start_index+N-1+Max_Sync_Jitter>length(xbuff)
        % duplicate one frame for slow sampling clock
%         current_start_index = current_start_index-N;
         disp('Buffer overflows. Sync lost.');
        state.Count_Acq = 0;
        state.Sync_Pos = NaN;
        state.Next_Start_Buffer_Index = 1;
        state.Sync_State = State_Supported{2};
    end
    
    if strcmpi(state.Sync_State, State_Supported{2})
        x = xbuff(1:N, :);
%         x = xbuff(7063:7063+N-1+Max_Sync_Jitter, :);
    else
        x = xbuff(current_start_index:current_start_index+N-1+Max_Sync_Jitter, :);
    end

    % linear cross correlation
    Rxpn = linxcorr_fft(x(:,Channel), pn)/sqrt(N*dot(x(:,Channel), x(:,Channel))+eps);
%     Rxpn2 = linxcorr_fft(x(:,2), pn)/sqrt(N*dot(x(:,2), x(:,2))+eps);
  %  Rxpn =linxcorr_fft(Rxpn1,Rxpn2)/sqrt(N*dot(Rxpn1(:,1), Rxpn1(:,1))+eps);
    Rxpn_AbsShiftAdd = abs(Rxpn(1:N));
    Rxpn_AbsShiftAdd(1:N-1) = Rxpn_AbsShiftAdd(1:N-1)+ ...
                                                             abs(Rxpn(1+N:2*N-1));
                                                         
%     plot(Rxpn_AbsShiftAdd);
    if strcmpi(state.Sync_State, State_Supported{2})
        [Max_Rxpn_AbsShiftAdd, Max_Pos] = max(Rxpn_AbsShiftAdd);
        Sync_Pos = mod(Max_Pos, N);
    elseif strcmpi(state.Sync_State, State_Supported{3})
        [Max_Rxpn_AbsShiftAdd, Max_Pos] = max(Rxpn_AbsShiftAdd([1:2*Max_Sync_Jitter, N]));
        Sync_Pos = mod(Max_Pos, 2*Max_Sync_Jitter+1)-Max_Sync_Jitter;
    else
        Sync_Pos = NaN;
    end
    
    
    Sink_Bit =NaN;   
    if strcmpi(state.Sync_State, State_Supported{2})    % acquisition
        Next_Start_Buffer_Index = 1;
        if Max_Rxpn_AbsShiftAdd<Threshold
            Count_Acq = 0;
            Sync_State = State_Supported{2};
            Sync_Pos = NaN;
        elseif state.Count_Acq==0
            Count_Acq = 1;
            Sync_State = State_Supported{2};
        elseif min([abs(Sync_Pos-last_sync_pos),abs(Sync_Pos-last_sync_pos+N), ...
                           abs(Sync_Pos-last_sync_pos-N)]) > Max_Sync_Jitter                       
            Count_Acq = 0;
            Sync_State = State_Supported{2};
        elseif state.Count_Acq==Max_Acqtime-1
            Count_Acq = Max_Acqtime;
            Count_Fail = 0;
            Sync_State = State_Supported{3};
            Next_Start_Buffer_Index = Sync_Pos+N-Max_Sync_Jitter+1;
        else
            Count_Acq = Count_Acq+1;
            Sync_State = State_Supported{2};
        end        
    elseif strcmpi(state.Sync_State, State_Supported{3})    % tracking
        if Max_Rxpn_AbsShiftAdd<Threshold
            Count_Fail = Count_Fail+1;
            Sync_Pos = 0;            % keep last sync position
            if Count_Fail==Max_Failtime
                Sync_Pos = NaN;
                Count_Acq = 0;
                Sync_State = State_Supported{2};
            else
                Sync_State = State_Supported{3};
            end
        else
            Count_Fail = 0;
            Sync_State = State_Supported{3};        
        end
        
        if strcmpi(Sync_State, State_Supported{3})
            frame_start = current_start_index+Sync_Pos+Max_Sync_Jitter;
            
            x = xbuff(frame_start:frame_start+N-1, :);
            [demoded_bit, sym, peak] = ccsk_modem(x(:,Channel), pn, M, 'demod', csk_polar);

%             [peak*sqrt(N/dot(x(:,1), x(:,1))+eps), Max_Rxpn_AbsShiftAdd]  % approximate
            
            Sink_Bit = demoded_bit;
            Next_Start_Buffer_Index = current_start_index+Sync_Pos;            
        else
            Next_Start_Buffer_Index = 1;
        end
    else
        error('Unsupported sync state.');
    end
end

state.Sync_State = Sync_State;
state.Sync_Pos = Sync_Pos;
state.Count_Acq = Count_Acq;
state.Count_Fail = Count_Fail;
state.Max_Rxpn_AbsShiftAdd = Max_Rxpn_AbsShiftAdd;
state.Sink_Bit = Sink_Bit;
state.Rxpn = Rxpn;
state.Rxpn_AbsShiftAdd = Rxpn_AbsShiftAdd;
state.Max_Pos = Max_Pos;
state.Next_Start_Buffer_Index = Next_Start_Buffer_Index;

state.Pn_Index = 1; % ÐÞ¸Äzcq
state.Current_Threshold = Threshold;

state.Threshold = Threshold;
state.Len_Pn = N;
state.State_Supported = State_Supported;
state.Max_Acqtime = Max_Acqtime;
state.Max_Failtime = Max_Failtime;
state.Max_Sync_Jitter = Max_Sync_Jitter;
state.Channel = Channel;

