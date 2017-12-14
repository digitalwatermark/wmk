function timer_callback_fcn(obj, event, h)
dv = 0.01;
v = get(h, 'value');
if v+dv>=1
    set(h, 'value', 1);
%     stop(obj);
%     delete(obj);
else
    set(h, 'value', v+dv);
end