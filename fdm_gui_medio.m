function varargout = fdm_gui_medio(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fdm_gui_medio_OpeningFcn, ...
                   'gui_OutputFcn',  @fdm_gui_medio_OutputFcn, ...
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

function fdm_gui_medio_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
im1=imread('fd2.png');
imshow(im1);
axes(handles.axes25);
set(handles.axes7,'Visible','off');
set(handles.axes8,'Visible','off');
set(handles.axes9,'Visible','off');
set(handles.axes10,'Visible','off');
set(handles.axes11,'Visible','off');
set(handles.axes12,'Visible','off');
set(handles.axes13,'Visible','off');
set(handles.axes14,'Visible','off');
set(handles.axes15,'Visible','off');
handles.output = hObject;
guidata(hObject, handles);

function varargout = fdm_gui_medio_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function fdm_calcular_Callback(hObject, eventdata, handles)
global s1 s2 s3 Fs
global signal_to_noise_ratio frec_carrier1 frec_carrier2 frec_carrier3
global senial_completa
%Las señales se modulan a diferentes portadoras
s1mod = ssbmod(s1,frec_carrier1,Fs);
s2mod = ssbmod(s2,frec_carrier2,Fs);
s3mod = ssbmod(s3,frec_carrier3,Fs);

set(handles.axes7); 
axes(handles.axes7);
esps1=abs(fft(s1mod));
plot(esps1),grid on,zoom,title('Espectro señal 1 modulada');

set(handles.axes8); 
axes(handles.axes8);
esps2=abs(fft(s2mod));
plot(esps2),grid on,zoom,title('Espectro señal 2 modulada');

set(handles.axes9); 
axes(handles.axes9);
esps3=abs(fft(s3mod));
plot(esps3),grid on,zoom,title('Espectro señal 3 modulada');

%Las señales moduladas se filtran en la banda determinada y se suman

%fs1=filter(filtro_banda1,s1mod);
%fs2=filter(filtro_banda2,s2mod);
%fs3=filter(filtro_banda3,s3mod);

fs1 = s1mod;
fs2 = s2mod;
fs3 = s3mod;
senial_completa = fs1+fs2+fs3;

set(handles.axes10); 
axes(handles.axes10);
esps1=abs(fft(fs1));
plot(esps1),grid on,zoom,title('Espectro señal 1 modulada y filtrada');

set(handles.axes11); 
axes(handles.axes11);
esps2=abs(fft(fs2));
plot(esps2),grid on,zoom,title('Espectro señal 2 modulada y filtrada');

set(handles.axes12); 
axes(handles.axes12);
esps3=abs(fft(fs3));
plot(esps3),grid on,zoom,title('Espectro señal 3 modulada y filtrada');

set(handles.axes13); 
axes(handles.axes13);
espf=abs(fft(senial_completa));
plot(espf),grid on,zoom,title('Espectro sumadas')

%Se añade ruido a la señal transmitida
set(handles.axes14); 
axes(handles.axes14);
esps1=abs(fft(senial_completa));
plot(esps1),grid on,zoom,title('Espectro señal completa');
    
senial_completa = awgn(senial_completa, signal_to_noise_ratio );

set(handles.axes15); 
axes(handles.axes15);
esps1=abs(fft(senial_completa));
plot(esps1),grid on,zoom,title('Espectro señal completa + ruido'); 

function generar_sonido_Callback(hObject, eventdata, handles)
%Medio de TX
%Reproducir las señales luego de pasarlas por el filtro
global s1 s2 s3 playerbeep
    player = audioplayer(s1,44100);
    playblocking(player);
    playblocking(playerbeep);

    player2 = audioplayer(s2,44100);
    playblocking(player2);
    playblocking(playerbeep);

    player3 = audioplayer(s3,44100);
    playblocking(player3);

function demo_mul_Callback(hObject, eventdata, handles)
fdm_gui_rx;
