function varargout = FSK_mod_demod_tx_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FSK_mod_demod_tx_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @FSK_mod_demod_tx_gui_OutputFcn, ...
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

function FSK_mod_demod_tx_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes1,'Visible','off');
%Inicio
global binaryImgVector xbinaryImg bp
%x=xbinaryImg;
x=binaryImgVector;
etiqueta=num2str(x);
set(handles.text_tx_bits,'string',[ '[ ',etiqueta,' ]']);
bp=.000001;
%Representación de la transmisión de información binaria como señal digital
bit=[]; 
for n=1:1:length(x)
    if x(n)==1;
       se=ones(1,100);
    else x(n)==0;
        se=zeros(1,100);
    end
     bit=[bit se];
end
t1=bp/100:bp/100:100*length(x)*(bp/100);
set(handles.axes1); 
axes(handles.axes1);
plot(t1,bit,'lineWidth',2.5);grid on;
axis([ 0 bp*length(x) -.5 1.5]);
ylabel('amplitude(volt)');
xlabel(' time(sec)');
title('Transmitiendo información como señal digital');
handles.output = hObject;
guidata(hObject, handles);

function varargout = FSK_mod_demod_tx_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function tx_calcular_Callback(hObject, eventdata, handles)

FSK_mod_demod_medio_gui;
