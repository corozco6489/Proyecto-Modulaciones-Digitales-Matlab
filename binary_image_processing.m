function varargout = binary_image_processing(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @binary_image_processing_OpeningFcn, ...
                   'gui_OutputFcn',  @binary_image_processing_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function binary_image_processing_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
axes(handles.axes1), axis off;
axes(handles.axes2), axis off;
handles.output = hObject;
handles.threshold_auto = 0;
handles.level = 0.5;
handles.threshold = 0.5;
set(handles.text_auto, 'Visible', 'off');
set(handles.checkbox_auto, 'Visible', 'off');
handles.plotBinary = 0;
handles.plotOrigin = 0;
handles.filterReady = 0;
handles.strelReady = 0;
%Subplot Grid
handles.x = 0;
handles.y = 0;
%subplot counter
handles.j = 0;
handles.k = 0;
% Update handles structure
guidata(hObject, handles);

function varargout = binary_image_processing_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function elegir_img_Callback(hObject, eventdata, handles)
global I
[handles.filename, handles.pathname] = uigetfile('*.jpg; *.jpeg; *.bmp; *.png; *.tif');
handles.imgFile = char([handles.pathname, handles.filename]);
handles.originalImg = imread(handles.imgFile);
I=handles.originalImg;
set(handles.text_aviso, 'String', handles.filename);
set(handles.text_aviso, 'Visible', 'on');
set(handles.text_auto, 'String', graythresh(handles.originalImg))
set(handles.text_auto, 'Visible', 'on');
set(handles.checkbox_auto, 'Value', 1);
set(handles.checkbox_auto, 'Visible', 'on');
guidata(hObject, handles);

function graficar_img_Callback(hObject, eventdata, handles)
global binaryImgVector xbinaryImg L 
    if handles.threshold_auto == 1
    handles.level = graythresh(handles.originalImg);
    set(handles.text_auto, 'String', handles.level);
    handles.binaryImg = im2bw(handles.originalImg, handles.level);
    else
        handles.binaryImg = im2bw(handles.originalImg, handles.threshold);
    end

    handles = createPlotGrid(hObject, handles);

    if handles.plotOrigin == 1 || handles.plotBinary == 1
        if handles.plotOrigin == 1
            set(handles.axes1);
            axes(handles.axes1);
            imshow(handles.originalImg);
        end
        if handles.plotBinary == 1
            set(handles.axes2);
            axes(handles.axes2);
            imshow(handles.binaryImg);
        end
    end
J = imresize(handles.binaryImg, 0.05);    
BWL=J;
%BWL=handles.binaryImg;
assignin('base','BWL',BWL);
L = length(BWL);
assignin('base','L',L);
disp(L);
ImgVector = J(:);
%ImgVector = handles.binaryImg(:);
binaryImgVector=ImgVector';
assignin('base','binaryImgVector',binaryImgVector);
xbinaryImg=binaryImgVector(1:15);
assignin('base','xbinaryImg',xbinaryImg);

function checkbox_auto_Callback(hObject, eventdata, handles)
handles.threshold_auto = get(hObject, 'Value');
if handles.threshold_auto == 1
    set(handles.text_auto, 'String', graythresh(handles.originalImg))
    set(handles.text_auto, 'Visible', 'on')
else
    set(handles.text_auto, 'Visible', 'off')
end
guidata(hObject, handles);

function handles = createPlotGrid(hObject, handles)
if handles.j == 1
    handles.x = 1;
    handles.y = 1;
end
if handles.j == 2
    handles.x = 2;
    handles.y = 1;
end
if handles.j == 3
    handles.x = 3;
    handles.y = 1;
end
if handles.j == 4
    handles.x = 2;
    handles.y = 2;
end
if (handles.j == 5 || handles.j == 6)
    handles.x = 3;
    handles.y = 2;
end
guidata(hObject, handles);

function menu_Callback(hObject, eventdata, handles)
close(binary_image_processing);clc;

function limpiar_Callback(hObject, eventdata, handles)
clc;
cla(handles.axes1);
axes(handles.axes1), axis off;
cla(handles.axes2);
axes(handles.axes2), axis off;

function checkbox_bin_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') == 1
    handles.plotBinary = 1;
else
    handles.plotBinary = 0;
end
guidata(hObject, handles);

function checkbox_orig_Callback(hObject, eventdata, handles)
if get(hObject, 'Value') == 1
    handles.plotOrigin = 1;
else
    handles.plotOrigin = 0;
end
guidata(hObject, handles);

function pskfreq_Callback(hObject, eventdata, handles)
global fpsk
fpsk=str2double(get(hObject,'String'));
if (fpsk<=40)
    handles.frqpsk=fpsk;
    set(handles.psk_mod_demod,'Enable','on');
else
    set(handles.psk_mod_demod,'Enable','off');
    set(handles.pskfreq,'String','Portad Frec');
    warndlg('La frecuencia debe ser inferior a 40 Hz.','Error');
end 
guidata(hObject, handles);

function pskfreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fskfreq_high_Callback(hObject, eventdata, handles)
global ffsk_var1
ffsk_var1=str2double(get(hObject,'String'));
if (ffsk_var1<=10)
    handles.frqfsk_high=ffsk_var1;
    set(handles.fskfreq_low,'Enable','on');
else
    set(handles.fsk_mod_demod,'Enable','off');
    set(handles.fskfreq_low,'Enable','off');
    set(handles.fskfreq_high,'String','Portad Frec High');
    warndlg('La frecuencia debe ser inferior a 10 Hz.','Error');
end 
guidata(hObject, handles);

function fskfreq_high_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fskfreq_low_Callback(hObject, eventdata, handles)
global ffsk_var2
ffsk_var2=str2double(get(hObject,'String'));
if (ffsk_var2<=10)
    handles.frqfsk_low=ffsk_var2;
    set(handles.fsk_mod_demod,'Enable','on');
else
    set(handles.fsk_mod_demod,'Enable','off');
    set(handles.fskfreq_low,'String','Portad Frec Low');
    warndlg('La frecuencia debe ser inferior a 10 Hz.','Error');
end 
guidata(hObject, handles);

function fskfreq_low_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function askfreq_Callback(hObject, eventdata, handles)
global fask
fask=str2double(get(hObject,'String'));
if (fask<=40)
    handles.frqask=fask;
    set(handles.ask_mod_demod,'Enable','on');
else
    set(handles.ask_mod_demod,'Enable','off');
    set(handles.askfreq,'String','Portad Frec');
    warndlg('La frecuencia debe ser inferior a 40 Hz.','Error');
end 
guidata(hObject, handles);


function askfreq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ask_mod_demod_Callback(hObject, eventdata, handles)
clc;ASK_mod_demod_tx_gui;

function psk_mod_demod_Callback(hObject, eventdata, handles)
clc;PSK_mod_demod_tx_gui;
       
function fsk_mod_demod_Callback(hObject, eventdata, handles)
clc;FSK_mod_demod_tx_gui;
    
function qam_mod_demod_Callback(hObject, eventdata, handles)
clc;QAM_mod_demod_tx_gui;
