function varargout = ASK_mod_demod_medio_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ASK_mod_demod_medio_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ASK_mod_demod_medio_gui_OutputFcn, ...
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

function ASK_mod_demod_medio_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes_modulacion,'Visible','off');
set(handles.axes_original,'Visible','off');
set(handles.axes_espectral,'Visible','off');
% Inicio
global xbinaryImg fask
bits = xbinaryImg; %Tiempo CORTO muestra
f=fask;
A0=1;
n = length(bits);
t = 0:.01:n;
x = 1:1:(n+1)*100;
for i = 1:n
    for j = i:.1:i+1
        bitsvector(x(i*100:(i+1)*100)) = bits(i);
    end
end
bitsvector = bitsvector(100:end);
sint = sin(2*pi*f*t);
st = bitsvector.*sint;

set(handles.axes1); 
axes(handles.axes1);
plot(t,bitsvector)
title('Señal de mensaje');
grid on ;
axis([0 n -2 +2]);

set(handles.axes2); 
axes(handles.axes2);
plot(t,sint)
title('Señal portadora');
grid on ;
axis([0 n -2 +2]);

set(handles.axes3); 
axes(handles.axes3);
plot(t,st)
title('ASK');
grid on ; 
axis([0 n -2 +2]);

var=strcat(' = ',num2str(A0),' *Sen(wt) ');
set(handles.edit_a,'String',num2str(var));
zoom on;
handles.output = hObject;
guidata(hObject, handles);

function varargout = ASK_mod_demod_medio_gui_OutputFcn(hObject, eventdata, handles) 
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

function medio_ask_Callback(hObject, eventdata, handles)
global xbinaryImg bp m f binaryImgVector A1 A2 mn
x = binaryImgVector; %Tiempo LARGO Completo
%x = xbinaryImg; %Tiempo CORTO Muestra
% Amplitud de señal portadora para información 1
A1 = get(handles.amp_uno,'String');
A1 = str2num(A1);
% Amplitud de señal portadora para información 0
A2 = get(handles.amp_dos,'String');
A2 = str2num(A2);
t2=bp/99:bp/99:bp;                 
ss=length(t2);
%Modulación ASK binaria               
br=1/bp; % tasa de bits
f=br*10; % Frecuencia de portadora
disp(f);
t2=bp/99:bp/99:bp;
m=[];
for (i=1:1:length(x))
    if (x(i)==1)
        y=A1*cos(2*pi*f*t2);
    else
        y=A2*cos(2*pi*f*t2);
    end
    m=[m y];
end

N=length(t2);
set(handles.axes_original); 
axes(handles.axes_original);
y=(A1).*sin(2*pi*(f)*t2);     %señal original 1
plot(t2,y), xlabel('Tiempo(seg)'), ylabel('Amplitud'), title('Señal Original'), grid minor;
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

t3=bp/99:bp/99:bp*length(x);
set(handles.axes_modulacion); 
axes(handles.axes_modulacion);
plot(t3,m), xlabel('time(sec)'), ylabel('amplitude(volt)'), title('Forma de onda para la modulación binaria ASK - Información binaria'), grid minor;
var=strcat(' = ',num2str(A1),' *Sen(wt) ');
set(handles.edit_b,'String',num2str(var));
var=strcat(' = ',num2str(A2),' *Sen(wt) ');
set(handles.edit_c,'String',num2str(var));

%Demodulación Binaria ASK
mn=[];
for n=ss:ss:length(m)
  t=bp/99:bp/99:bp;
  y=cos(2*pi*f*t); % señal portadora
  mm=y.*m((n-(ss-1)):n);
  t4=bp/99:bp/99:bp;
  z=trapz(t4,mm)
  zz=round((2*z/bp))                                     
  if(zz>((A1+A2)/2)) % logic level = ((A1+A2)/2) = 7.5
    a=1;
  else
    a=0;
  end
  mn=[mn a];
end
zoom on;

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

function ecuacion_b_Callback(hObject, eventdata, handles)

function ecuacion_b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_b_Callback(hObject, eventdata, handles)

function edit_b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ecuacion_c_Callback(hObject, eventdata, handles)

function ecuacion_c_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_c_Callback(hObject, eventdata, handles)

function edit_c_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function demu_ask_Callback(hObject, eventdata, handles)
ASK_mod_demod_rx_gui;
