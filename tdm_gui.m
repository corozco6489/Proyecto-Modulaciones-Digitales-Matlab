function varargout = tdm_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tdm_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @tdm_gui_OutputFcn, ...
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

function tdm_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
im1=imread('td2.png');
axes(handles.axes8);
imshow(im1);
axes(handles.axes1), axis off;
axes(handles.axes2), axis off;
axes(handles.axes3), axis off;
axes(handles.axes4), axis off;
axes(handles.axes5), axis off;
axes(handles.axes6), axis off;
axes(handles.axes7), axis off;
handles.output = hObject;
guidata(hObject, handles);

function varargout = tdm_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function tdm_calcular_Callback(hObject, eventdata, handles)
%Código para multiplexación por división de tiempo
% Signal generation
x=0:.5:4*pi;
sig1=8*sin(x);
l=length(sig1);
sig2=8*triang(l);
% Visualización de ambas señales
set(handles.axes1); 
axes(handles.axes1);
plot(sig1);
title('Señal sinusoidal');
ylabel('Amplitude');
xlabel('Time');
grid on;

set(handles.axes2); 
axes(handles.axes2);
plot(sig2);
title('Señal triangular');
ylabel('Amplitude');
xlabel('Time');
grid on;
% Visualización de ambas señales muestreadas
set(handles.axes3); 
axes(handles.axes3);
stem(sig1);
title('Señal sinusoidal muestreada');
ylabel('Amplitude');
xlabel('Time');
grid on;
set(handles.axes4); 
axes(handles.axes4);
stem(sig2);
title('Señal triangular muestreada');
ylabel('Amplitude');
xlabel('Time');
grid on;

l1=length(sig1);
l2=length(sig2);
 for i=1:l1
  sig(1,i)=sig1(i);
  sig(2,i)=sig2(i);
 end  

% TDM de ambas señales de cuantización
tdmsig=reshape(sig,1,2*l1);               
% Visualización de la señal TDM
set(handles.axes5); 
axes(handles.axes5);
stem(tdmsig);
title('Señal TDM');
ylabel('Amplitude');
xlabel('Time');
grid on;

% Desmultiplexación de la señal TDM
 demux=reshape(tdmsig,2,l1);
 for i=1:l1
  sig3(i)=demux(1,i);
  sig4(i)=demux(2,i);
 end  
 
% visualización de señal demultiplexada
 set(handles.axes6); 
 axes(handles.axes6);
 plot(sig3);
 title('Señal sinusoidal recuperada');
 ylabel('Amplitude');
 xlabel('Time');
 grid on;
 
 set(handles.axes7); 
 axes(handles.axes7)
 plot(sig4);
 title('Señal triangular recuperada');
 ylabel('Amplitude');
 xlabel('Time');
 grid on;
