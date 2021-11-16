function varargout = receiver_image_analyze(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @receiver_image_analyze_OpeningFcn, ...
                   'gui_OutputFcn',  @receiver_image_analyze_OutputFcn, ...
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

function receiver_image_analyze_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
axes(handles.axes1), axis off;
axes(handles.axes2), axis off;
axes(handles.axes3), axis off;
handles.output = hObject;
handles.threshold_auto = 0;
handles.level = 0.5;
handles.threshold = 0.5;
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

function varargout = receiver_image_analyze_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function graficar_img_Callback(hObject, eventdata, handles)
global L BinaryinformationReciver I binaryImgVector
etiqueta=num2str(BinaryinformationReciver);
set(handles.text_tx_bits,'string',[ '[ ',etiqueta,' ]']);
M = reshape(BinaryinformationReciver,L,L); %Tiempo LARGO
%M = reshape(binaryImgVector,L,L); %Tiempo CORTO muestra
AsImage = uint8(M.*(255/10));
set(handles.axes1);
axes(handles.axes1);
imshow(AsImage)
BackAsMatrix = double(AsImage).*(10/255);
set(handles.axes2);
axes(handles.axes2);
imshow(BackAsMatrix)
oimg=I;
H=fspecial('unsharp');
sharpd_img=imfilter(oimg,H,'replicate');
axes(handles.axes3);
imshow(sharpd_img);

function menu_Callback(hObject, eventdata, handles)
close(receiver_image_analyze);clc;

function limpiar_Callback(hObject, eventdata, handles)
clc;
cla(handles.axes1);
axes(handles.axes1), axis off;
cla(handles.axes2);
axes(handles.axes2), axis off;
cla(handles.axes3);
axes(handles.axes3), axis off;
