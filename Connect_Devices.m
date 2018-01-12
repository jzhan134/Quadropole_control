function [inst, camera] = Connect_Devices(opt_device)
% Connect to function generator
if opt_device == 1
    inst = visa('agilent','USB0::0x0957::0x0407::MY44031300::0::INSTR');
else
    inst = visa('agilent','USB0::0x0957::0x2C07::MY52805062::0::INSTR');
end
fopen(inst);

% Connect to camera
DEVICE = 'hamamatsu';            % Device driver used by your camera
% FORMAT = 'MONO8_1344x1024'; % bin = 1
% FORMAT = 'MONO8_BIN2x2_672x512'; % bin = 2
FORMAT = 'MONO8_BIN4x4_336x256'; % bin = 4
% FORMAT = 'MONO8_BIN8x8_168x128'; % bin = 8
camera = videoinput(DEVICE,1,FORMAT);
% parameter = getselectedsource(camera);
set(camera,'ReturnedColorSpace','gray'); % Return only grayscale images
triggerconfig(camera,'Manual'); % Require manually triger the capture
camera.TriggerRepeat = Inf; % Allow infinite times of trigger
camera.FramesPerTrigger = 1; % Capture 560 frames per trigger
src = getselectedsource(camera);
src.ExposureTime = 1/100; % Video exposure time set to 0.02s
start(camera)

% % Create a figure window.
% hFig = figure('Toolbar','none',...
%     'Menubar', 'none',...
%     'NumberTitle','Off',...
%     'Name','Video Microscopy');
% textsize = 7;
% hTextTLabel = uicontrol('style','text','String','Time', ...
%     'Units','normalized','FontWeight','bold',...
%     'FontSize',textsize,'Position',[0.9 0.0 0.10 0.03]);
% vidRes = get(vid, 'VideoResolution');
% imWidth = vidRes(1);
% imHeight = vidRes(2);
% nBands = get(vid, 'NumberOfBands');
% hImage = image( zeros(imHeight, imWidth, nBands) );
% 
% figSize = get(hFig,'Position');
% figWidth = figSize(3);
% figHeight = figSize(4);
% set(gca,'unit','pixels',...
%     'position',[ ((figWidth - imWidth)/2)...
%     ((figHeight - imHeight)/2)...
%     imWidth imHeight ]);
% 
% setappdata(hImage,'UpdatePreviewWindowFcn',@dispdata_fcn);
% 
% setappdata(hImage,'HandleToTLabel',hTextTLabel);
% 
% preview(vid,hImage);
end