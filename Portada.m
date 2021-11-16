function varargout = Portada(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Portada_OpeningFcn, ...
                   'gui_OutputFcn',  @Portada_OutputFcn, ...
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

function Portada_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
im1=imread('fisei.jpg');
axes(handles.axes1);
imshow(im1);
[a,map]=imread('salir.png');
[r,c,d]=size(a);
x=ceil(r/80);
y=ceil(c/80);
g=a(1:x:end,1:y:end,:);
g(g==255)=5.5*255;
set(handles.pushbutton1,'CData',g);
handles.output = hObject;
guidata(hObject, handles);

function varargout = Portada_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
close all;clc;

function modulacion_general_Callback(hObject, eventdata, handles)
binary_image_processing;

function fdm_general_Callback(hObject, eventdata, handles)
fdm_gui_tx;

function tdm_general_Callback(hObject, eventdata, handles)
tdm;tdm_gui;

function pcm_calcular_Callback(hObject, eventdata, handles)
pcm_gui;

function cod_errores_Callback(hObject, eventdata, handles)
code_hamming;

function bits_pariedad_Callback(hObject, eventdata, handles)
parity_bits;

function crc_aplicacion_Callback(hObject, eventdata, handles)
CRC_GUI;

function ack_calcular_Callback(hObject, eventdata, handles)
ARQ_GUI;
