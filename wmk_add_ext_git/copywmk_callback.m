
function copywmk_callback(hObject, eventdata, handles)

idx = get(gcbo, 'value');
strcell = get(gcbo, 'string');

if ~isempty(idx)
    str = strcell{idx(1)};
    for ii=2:length(idx)
        str = sprintf('%s\n%s', str, strcell{idx(ii)});
    end
    clipboard('copy', str);
end
