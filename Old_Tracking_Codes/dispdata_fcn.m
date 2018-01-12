function dispdata_fcn(obj,event,himage)
% Display data on video window function.

global t

% Get time for frame
tstr = round(t*10)/10;
% Get handle to text label uicontrol.
ht = getappdata(himage,'HandleToTLabel');
% Set the value of the text label.
set(ht,'String',['t =',num2str(tstr)]);

% Display image data.
set(himage, 'CData', event.Data)
end