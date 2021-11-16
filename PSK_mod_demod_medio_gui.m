function varargout = PSK_mod_demod_medio_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PSK_mod_demod_medio_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @PSK_mod_demod_medio_gui_OutputFcn, ...
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

function PSK_mod_demod_medio_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes_modulacion,'Visible','off');
set(handles.axes_original,'Visible','off');
set(handles.axes_espectral,'Visible','off');
%Inicio
global binaryImgVector xbinaryImg fpsk
%bits = binaryImgVector;
bits = xbinaryImg;
f=fpsk;
A0=1;
n = length(bits);
t = 0:.01:n;
x = 1:1:(n+1)*100;
for i = 1:n
 if (bits(i) == 0)
 bitscoded(i) = -1;
 else
 bitscoded(i) = 1;
 end
 for j = i:.1:i+1
 bitsvector(x(i*100:(i+1)*100)) = bitscoded(i);
 end
end 
bitsvector = bitsvector(100:end);
sint = sin(2*pi*f*t);
modst = bitsvector.*sint;

set(handles.axes1); 
axes(handles.axes1);
plot(t,bitsvector);
title('Señal de mensaje');
grid on ;
axis([0 n -2 +2]);

set(handles.axes2); 
axes(handles.axes2);
plot(t,sint)
title('Señal portadora');
grid on ;
axis([0 n -2 +2])

set(handles.axes3); 
axes(handles.axes3);
plot(t,modst)
title('PSK');
grid on ;
axis([0 n -2 +2])

var=strcat(' = ',num2str(A0),' *Sen(Wp(t)) ');
set(handles.edit_a,'String',num2str(var));
zoom on;
handles.output = hObject;
guidata(hObject, handles);

function varargout = PSK_mod_demod_medio_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function amp_uno_Callback(hObject, eventdata, handles)
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','0')
end

function amp_uno_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function amp_dos_Callback(hObject, eventdata, handles)
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','0')
end

function amp_dos_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tx_calcular_Callback(hObject, eventdata, handles)
global  binaryImgVector xbinaryImg bp m f A
x=binaryImgVector;
%x=xbinaryImg;
%Amplitud de señal portadora
A = get(handles.amp_uno,'String');
A = str2num(A);
%Modulación binaria PSK
br=1/bp;
f=br*2;
t2=bp/99:bp/99:bp;
m=[];
for (i=1:1:length(x))
    if (x(i)==1)
        y=A*cos(2*pi*f*t2);
    else
        y=A*cos(2*pi*f*t2+pi);   %A*cos(2*pi*f*t+pi) means -A*cos(2*pi*f*t)
    end
    m=[m y];
end
t3=bp/99:bp/99:bp*length(x);
set(handles.axes_modulacion); 
axes(handles.axes_modulacion);
plot(t3,m);
xlabel('time(sec)');
ylabel('amplitude(volt)');
title('Forma de onda para la modulación binaria PSK - Información binaria');
var=strcat(' = ',num2str(A),' *Sen(Wp(t)) ');
set(handles.edit5,'String',num2str(var));

N=length(t3);
set(handles.axes_original); 
axes(handles.axes_original);
y=(A).*sin(2*pi*(f)*t3);     %señal original 1
plot(t3,y), xlabel('Tiempo(seg)'), ylabel('Amplitud'), title('Señal Original'), grid minor;
F=fft(y)/sqrt(N);                        % trasformada de Fourier de x
%Para dibujarlo, despreciamos la mitad del dominio debido a la simetría
omega=0.5*f*linspace(0,1,floor(N/2)+1); % vector de frecuencias discretas
range=(1:floor(N/2)+1);                  % rango del espectro de potencia
P=abs(F(range)).^2;                      % espectro de potencia de la señal x
%set(handles.axes_espectral); 
%axes(handles.axes_espectral);
%plot(omega,P), xlabel('Frecuencia (Hz)'), ylabel('dB/Hz'), title('Espectro de potencia')
% Densidad espectral de potencia
nfft = 2^nextpow2(length(y));
Pxx = abs(fft(y,nfft)).^2/length(y)/(f);
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',(f));
set(handles.axes_espectral); 
axes(handles.axes_espectral);
plot(Hpsd), xlabel('Frecuencia (Hz)'), ylabel('dB/Hz'), title('Densidad espectral de Potencia'), grid minor;
zoom on;

function demo_psk_Callback(hObject, eventdata, handles)
PSK_mod_demod_rx_gui;

function ecuacion_a_Callback(hObject, eventdata, handles)

function ecuacion_a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_a_Callback(hObject, eventdata, handles)

function edit_a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)

function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
