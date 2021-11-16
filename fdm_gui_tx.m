function varargout = fdm_gui_tx(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fdm_gui_tx_OpeningFcn, ...
                   'gui_OutputFcn',  @fdm_gui_tx_OutputFcn, ...
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

function fdm_gui_tx_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
im1=imread('fd1.png');
axes(handles.axes25);
imshow(im1);
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.axes3,'Visible','off');
set(handles.axes4,'Visible','off');
set(handles.axes5,'Visible','off');
set(handles.axes6,'Visible','off');
handles.output = hObject;
guidata(hObject, handles);

function varargout = fdm_gui_tx_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function fdm_calcular_Callback(hObject, eventdata, handles)
global s1 s2 s3 playerbeep
global signal_to_noise_ratio frec_carrier1 frec_carrier2 frec_carrier3 Fs
global filtro_banda3 filtro_banda4 filtro_banda5
%Ancho de banda para cada banda de frecuencia en Hz
bandwidth = 4000;
guarda_medios = 300;
signal_to_noise_ratio = 20;
% La primera señal se colocará en el tercer canal
% La segunda en el cuarto y el tercero en el quinto.
% Frecuencia de las portadoras en Hz
frec_carrier1 = bandwidth*3;
frec_carrier2 = bandwidth*4;
frec_carrier3 = bandwidth*5;
Fs = frec_carrier3*2+5000;

frec_corte_filtro_pasabajo = 2500;

%Definir filtros
[B,A] = butter(4,frec_corte_filtro_pasabajo/(Fs/2));
pasa_bajo = @(S) filter(B,A,S);

[C1,D1] = butter(2,[bandwidth*2+guarda_medios bandwidth*3-guarda_medios]/(Fs/2));
filtro_banda3 = @(S) filter(C1,D1,S);

[C2,D2] = butter(2,[bandwidth*3+guarda_medios bandwidth*4-guarda_medios]/(Fs/2));
filtro_banda4 = @(S) filter(C2,D2,S);

[C3,D3] = butter(2,[bandwidth*4+guarda_medios bandwidth*5-guarda_medios]/(Fs/2));
filtro_banda5 = @(S) filter(C3,D3,S);

%Leer los archivoz
s1 = audioread('1.wav');
longituds1 = length(s1);

s2 = audioread('2.wav');
longituds2 = length(s2);

s3 = audioread('3.wav');
longituds3 = length(s3);

beep = audioread('beep.wav');
playerbeep = audioplayer(beep,44100);

%Truncar a la longitud del menor
longitud_minima = min([longituds1 longituds2 longituds3]);
t = linspace(0,5, longitud_minima);

s1 = s1(1:longitud_minima);
s2 = s2(1:longitud_minima);
s3 = s3(1:longitud_minima);

%Graficar los espectros de las señales
set(handles.axes1); 
axes(handles.axes1);
esps1=abs(fft(s1));
plot(esps1),grid on,zoom,title('Espectro señal 1');
ylabel('amplitude');
xlabel(' time(sec)');
set(handles.axes2); 
axes(handles.axes2);
esps2=abs(fft(s2));
plot(esps2),grid on,zoom,title('Espectro señal 2');
ylabel('amplitude');
xlabel(' time(sec)');
set(handles.axes3); 
axes(handles.axes3);
esps3=abs(fft(s3));
plot(esps3),grid on,zoom,title('Espectro señal 3');
ylabel('amplitude');
xlabel(' time(sec)');
%Las señales se pasan por un filtro pasa bajo y se grafican
s1 = pasa_bajo(s1);
s2 = pasa_bajo(s2);
s3 = pasa_bajo(s3);

set(handles.axes4); 
axes(handles.axes4);
esps1=abs(fft(s1));
plot(esps1),grid on,zoom,title('Espectro señal 1 filtrada');
ylabel('amplitude');
xlabel(' time(sec)');
set(handles.axes5); 
axes(handles.axes5);
esps2=abs(fft(s2));
plot(esps2),grid on,zoom,title('Espectro señal 2 filtrada');
ylabel('amplitude');
xlabel(' time(sec)');
set(handles.axes6); 
axes(handles.axes6);
esps3=abs(fft(s3));
plot(esps3),grid on,zoom,title('Espectro señal 3 filtrada');
ylabel('amplitude');
xlabel(' time(sec)');
function generar_sonido_Callback(hObject, eventdata, handles)
%TX
%Reproducir las señales originales
global s1 s2 s3 playerbeep
    player = audioplayer(s1,44100);
    playblocking(player);
    playblocking(playerbeep);

    player2 = audioplayer(s2,44100);
    playblocking(player2);
    playblocking(playerbeep);

    player3 = audioplayer(s3,44100);
    playblocking(player3);
    

function medio_mul_Callback(hObject, eventdata, handles)
fdm_gui_medio;
