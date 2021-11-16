function varargout = FSK_mod_demod_medio_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FSK_mod_demod_medio_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @FSK_mod_demod_medio_gui_OutputFcn, ...
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

function FSK_mod_demod_medio_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes_modulacion,'Visible','off');
set(handles.axes_original,'Visible','off');
set(handles.axes_espectral,'Visible','off');
%Inicio
global binaryImgVector xbinaryImg ffsk_var1 ffsk_var2
A0=1;

fc1=ffsk_var2;
fc2=ffsk_var1;
Tb=1; 
t=0:(Tb/100):Tb;
c1=sqrt(2/Tb)*sin(2*pi*fc1*t);
c2=sqrt(2/Tb)*sin(2*pi*fc2*t);

[m]=xbinaryImg;
%[m]=binaryImgVector;
t1=0;t2=Tb;

set(handles.axes1); 
axes(handles.axes1);
axis([0 8 -2 2]);stem(m);
title('Señal de mensaje');
xlabel('n');
ylabel('b(n)');
grid on;

set(handles.axes2); 
axes(handles.axes2);
plot(t,c1);
title('Señal portadora 1');
xlabel('t(seg)')
ylabel('c1(t)');
grid on;

set(handles.axes3); 
axes(handles.axes3);
plot(t,c2);
title('Señal portadora 2');
xlabel('t(seg)')
ylabel('c2(t)');
grid on;
for i=1:length(m)
    t=t1:(Tb/100):t2;
    if m(i)>0.5
        m(i)=1;
        m_s=ones(1,length(t));
        invm_s=zeros(1,length(t));
    else
        m(i)=0;
        m_s=zeros(1,length(t));
        invm_s=ones(1,length(t));
    end
    message(i,:)=m_s;
    fsk_sig1(i,:)=c2.*m_s;
    fsk_sig2(i,:)=c1.*invm_s;
    fsk=fsk_sig1+fsk_sig2;
    set(handles.axes4); 
    axes(handles.axes4);
    axis([0 8 -2 2]);
    plot(t,message(i,:),'r');
    title('Señal de mensaje');
    xlabel('t(seg)')
    ylabel('m(t)');
    grid on;
    hold on;
    set(handles.axes5); 
    axes(handles.axes5);
    plot(t,fsk(i,:));
    title('FSK');
    xlabel('t(seg)')
    ylabel('s(t)');
    grid on;
    hold on;
    t1=t1+(Tb+.01);
    t2=t2+(Tb+.01);
end
hold off

var=strcat(' = ',num2str(A0),' *Sen(wt) ');
set(handles.edit_a,'String',num2str(var));
zoom on;
handles.output = hObject;
guidata(hObject, handles);

function varargout = FSK_mod_demod_medio_gui_OutputFcn(hObject, eventdata, handles) 
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

function tx_calcular_Callback(hObject, eventdata, handles)
global xbinaryImg binaryImgVector bp m A f1 f2
x=binaryImgVector;
%x=xbinaryImg;
% Amplitud de la señal portadora
v1 = get(handles.amp_uno,'String');
A = str2num(v1);
% Modulación binaria FSK                         
br=1/bp;
f1=br*8; %frecuencia de portadora para información de señal 1
f2=br*2; %frecuencia de portadora para información de señal 0
t2=bp/99:bp/99:bp;
m=[];
for (i=1:1:length(x))
    if (x(i)==1)
        y=A*cos(2*pi*f1*t2);
    else
        y=A*cos(2*pi*f2*t2);
    end
    m=[m y];
end
t3=bp/99:bp/99:bp*length(x);
set(handles.axes_modulacion); 
axes(handles.axes_modulacion);
plot(t3,m);
xlabel('time(sec)');
ylabel('amplitude(volt)');
title('Forma de onda para la modulación binaria FSK - Información binaria');
var=strcat(' = ',num2str(A),' *Sen(2*pi* ',num2str(f2),' )');
set(handles.edit5,'String',num2str(var));
var=strcat(' = ',num2str(A),' *Sen(2*pi* ',num2str(f1),' ) ');
set(handles.edit6,'String',num2str(var));
N=length(t3);
set(handles.axes_original); 
axes(handles.axes_original);
y=(A).*sin(2*pi*(f1)*t3);     %señal original 1
plot(t3,y), xlabel('Tiempo(seg)'), ylabel('Amplitud'), title('Señal Original'), grid minor;
F=fft(y)/sqrt(N);                        % trasformada de Fourier de x
%Para dibujarlo, despreciamos la mitad del dominio debido a la simetría
omega=0.5*f1*linspace(0,1,floor(N/2)+1); % vector de frecuencias discretas
range=(1:floor(N/2)+1);                  % rango del espectro de potencia
P=abs(F(range)).^2;                      % espectro de potencia de la señal x
%set(handles.axes_espectral); 
%axes(handles.axes_espectral);
%plot(omega,P), xlabel('Frecuencia (Hz)'), ylabel('dB/Hz'), title('Espectro de potencia')
% Densidad espectral de potencia
nfft = 2^nextpow2(length(y));
Pxx = abs(fft(y,nfft)).^2/length(y)/(f1);
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',(f1));
set(handles.axes_espectral); 
axes(handles.axes_espectral);
plot(Hpsd), xlabel('Frecuencia (Hz)'), ylabel('dB/Hz'), title('Densidad espectral de Potencia'), grid minor;
zoom on;

function demu_fsk_Callback(hObject, eventdata, handles)

FSK_mod_demod_rx_gui;

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


function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
