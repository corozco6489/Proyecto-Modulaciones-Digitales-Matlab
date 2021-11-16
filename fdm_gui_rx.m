function varargout = fdm_gui_rx(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fdm_gui_rx_OpeningFcn, ...
                   'gui_OutputFcn',  @fdm_gui_rx_OutputFcn, ...
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

function fdm_gui_rx_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
im1=imread('fd3.png');
imshow(im1);
set(handles.axes16,'Visible','off');
set(handles.axes17,'Visible','off');
set(handles.axes18,'Visible','off');
set(handles.axes19,'Visible','off');
set(handles.axes20,'Visible','off');
set(handles.axes21,'Visible','off');
set(handles.axes22,'Visible','off');
set(handles.axes23,'Visible','off');
set(handles.axes24,'Visible','off');
handles.output = hObject;
guidata(hObject, handles);

function varargout = fdm_gui_rx_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function fdm_calcular_Callback(hObject, eventdata, handles)
global filtro_banda3 filtro_banda4 filtro_banda5 senial_completa
global frec_carrier1 frec_carrier2 frec_carrier3
global demods1 demods2 demods3

%Definir filtro
frec_corte_filtro_pasabajo = 2500;
Fs = frec_carrier3*2+5000;
[B,A] = butter(4,frec_corte_filtro_pasabajo/(Fs/2));
pasa_bajo = @(S) filter(B,A,S);


%En el RX se filtra cada banda
%Se reciben las señales y se filtran

%demuxs1=filter(filtro_banda1,senial_completa);
demuxs1 = filtro_banda3(senial_completa);

%demuxs2=filter(filtro_banda2,senial_completa);
demuxs2 = filtro_banda4(senial_completa);

%demuxs3=filter(filtro_banda3,senial_completa);
demuxs3 = filtro_banda5(senial_completa);

set(handles.axes16); 
axes(handles.axes16);
esps1=abs(fft(demuxs1));
plot(esps1),grid on,zoom,title('Espectro señal 1 filtrada');

set(handles.axes17); 
axes(handles.axes17);
esps2=abs(fft(demuxs2));
plot(esps2),grid on,zoom,title('Espectro señal 2 filtrada');

set(handles.axes18); 
axes(handles.axes18);
esps3=abs(fft(demuxs3));
plot(esps3),grid on,zoom,title('Espectro señal 3 filtrada');

% Cada banda recuperada se demodula para regresar la señal a la frecuencia indicada

demods1 = ssbdemod(demuxs1, frec_carrier1,Fs);
demods2 = ssbdemod(demuxs2, frec_carrier2,Fs);
demods3 = ssbdemod(demuxs3, frec_carrier3,Fs);

set(handles.axes19); 
axes(handles.axes19);
esps1=abs(fft(demods1));
plot(esps1),grid on,zoom,title('Espectro señal 1 demodulada');

set(handles.axes20); 
axes(handles.axes20);
esps2=abs(fft(demods2));
plot(esps2),grid on,zoom,title('Espectro señal 2 demodulada');

set(handles.axes21); 
axes(handles.axes21);
esps3=abs(fft(demods3));
plot(esps3),grid on,zoom,title('Espectro señal 3 demodulada');

%La señal recuperada se pasa por un filtro pasabajo
demods1 = pasa_bajo(demods1);
demods2 = pasa_bajo(demods2);
demods3 = pasa_bajo(demods3);

set(handles.axes22); 
axes(handles.axes22);
esps1=abs(fft(demods1));
plot(esps1),grid on,zoom,title('Espectro señal 1 demodulada');

set(handles.axes23); 
axes(handles.axes23);
esps2=abs(fft(demods2));
plot(esps2),grid on,zoom,title('Espectro señal 2 demodulada');

set(handles.axes24); 
axes(handles.axes24);
esps3=abs(fft(demods3));
plot(esps3),grid on,zoom,title('Espectro señal 3 demodulada');

function generar_sonido_Callback(hObject, eventdata, handles)
%RX
%Reproducir las señales luego de la transmision
global demods1 demods2 demods3 playerbeep
player4 = audioplayer(demods1,44100);
playblocking(player4);
playblocking(playerbeep);

player5 = audioplayer(demods2,44100);
playblocking(player5);
playblocking(playerbeep);

player6 = audioplayer(demods3,44100);
playblocking(player6);
