function varargout = QAM_mod_demod_medio_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QAM_mod_demod_medio_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @QAM_mod_demod_medio_gui_OutputFcn, ...
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

function QAM_mod_demod_medio_gui_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.axes1), axis off;
axes(handles.axes2), axis off;
axes(handles.axes3), axis off;
axes(handles.axes4), axis off;
axes(handles.axes5), axis off;
zoom on;
handles.output = hObject;
guidata(hObject, handles);

function varargout = QAM_mod_demod_medio_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function generar_proceso_Callback(hObject, eventdata, handles)
set(handles.entrada_inf, 'visible', 'on');
set(handles.salida_inf, 'visible', 'on');
set(handles.calculo_inf, 'visible', 'on');
global binaryImgVector
g=binaryImgVector;
t=0:2*pi/99:2*pi;
cp=[];sp=[];
mod=[];mod1=[];bit=[];

for n=1:length(g);
    if g(n)==0;
        die=-ones(1,100);   %Modulante
        se=zeros(1,100);    %Señal
    else g(n)==1;
        die=ones(1,100);    %Modulante
        se=ones(1,100);     %Señal
    end
    c=1*sin(2*t);
    cp=[cp die];
    mod=[mod c];
    bit=[bit se];
end

bpsk=cp.*mod;
set(handles.axes1); 
axes(handles.axes1);
plot(bit,'LineWidth',2);grid on;
title('SEÑAL DE ENTRADA');
axis([0 100*length(g) -2.5 2.5]);

set(handles.axes5); 
axes(handles.axes5);
plot(bit,'LineWidth',2);grid on;
title('SEÑAL DEMODULADA');
axis([0 100*length(g) -2.5 2.5]);

set(handles.axes2); 
axes(handles.axes2);
x = linspace(1,5*pi,300);
plot(x,diric(x,7)); grid on; axis tight;
title('FUNCION SA');

set(handles.axes3); 
axes(handles.axes3);
msg=g;
[m,n] = size(msg);
    samples_per_symbol = 50;  
    f = 100;
    t=0:2*pi/(samples_per_symbol-1):2*pi;
    modulated = zeros( m, samples_per_symbol*n );
    t = repmat( t, 1, n );
    for k = 1:m
        temp = repmat( msg(k,:), samples_per_symbol, 1);
        phi = (reshape( temp, samples_per_symbol*n, 1) + 1)*f;
        modulated(k,:) = sin( phi .* t' )';
    end
    for k = 1:m
        Hz = -samples_per_symbol/2:samples_per_symbol/length(modulated(k,:)):samples_per_symbol/2;
        Hz = Hz(1:length(modulated(k,:)));
        plot(Hz, abs(fftshift(fft(modulated(k,:)))));grid on;
        title('QAM ESPECTRO');
        xlabel('Hz');
        xlim( [-10 10] );
    end     
set(handles.axes4); 
axes(handles.axes4); 
A1=str2double(get(handles.amp_uno,'String'));
A2=str2double(get(handles.amp_dos,'String'));
f1=str2double(get(handles.frec_uno,'String'));
f2=str2double(get(handles.frec_dos,'String'));
%A1 = 2; f1 = 5; 
p1 = 0;
%A2 = 4; f2 = 20; 
p2 = 0;
fs = 1000;
t1 = 0: 1/fs : 1;
s1 = A1*sin(2*pi*f1*t1 + p1);
s2 = A2*sin(2*pi*f2*t1 + p2);
s3 = s1.*s2;
s3_01 = A1*A2*(sin(2*pi*f1*t1));
s3_02 = -A1*A2*(sin(2*pi*f1*t1));
s4 = (A2 + s1).*sin(2*pi*f2*t1);
s4_01 = A2 + s1;
s4_02 = -A2 - s1;
N = 2^nextpow2(length(t1));
f = fs * (0 : N/2) / N; 
s3_f = (2/N)*abs(fft(s3,N));
s4_f = (2/N)*abs(fft(s4,N));
plot(t1,s4); grid on;
title('QAM');

N=length(t1);
F=fft(s4)/sqrt(N);                        % trasformada de Fourier de x
%Para dibujarlo, despreciamos la mitad del dominio debido a la simetría
omega=0.5*f2*linspace(0,1,floor(N/2)+1); % vector de frecuencias discretas
range=(1:floor(N/2)+1);                  % rango del espectro de potencia
P=abs(F(range)).^2;                      % espectro de potencia de la señal x
set(handles.axes_espectral_p); 
axes(handles.axes_espectral_p);
plot(omega,P), xlabel('Frecuencia (Hz)'), ylabel('dB/Hz'), title('Espectro de potencia')
% Densidad espectral de potencia
nfft = 2^nextpow2(length(s4));
Pxx = abs(fft(s4,nfft)).^2/length(s4)/(f2);
Hpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',(f2));
set(handles.axes_espectral); 
axes(handles.axes_espectral);
plot(Hpsd), xlabel('Frecuencia (Hz)'), ylabel('dB/Hz'), title('Densidad espectral de Potencia'), grid minor;

%Formulas
var=strcat(' Emp(t)= a_n*cos*(w*t)+b_n*sen*(w*t)=',num2str(A1),' *cos(',num2str(f1),'*t)+',num2str(A2),'*sen(',num2str(f2),'*t)');
set(handles.cinco,'String',num2str(var));
div=((A1.^2)+(A2.^2)).^(1/2);
var=strcat(' Anm=(An^2+Bm^2)^1/2=(',num2str(A1),'^2',num2str(A2),'^2)',num2str(f2),'^1/2=',num2str(div));
set(handles.seis,'String',num2str(var));
hn=atan(A2/A1);
mult=div*cos(hn);
var=strcat(' An=Anm*cos(Hnm)=',num2str(mult));
set(handles.siete,'String',num2str(var));    
var=strcat(' Hnm=arctan(Bn/An)=',num2str(hn));
set(handles.ocho,'String',num2str(var));  
var=strcat(' a=A*cos(h)=',num2str(A1),'cos(h)');
set(handles.nueve,'String',num2str(var));  
var=strcat(' b=A*sen(h)=',num2str(A2),'sen(h)');
set(handles.diez,'String',num2str(var));       
zoom on;

function amp_uno_Callback(hObject, eventdata, handles)
global A1
A1=str2double(get(handles.amp_uno,'String'));
if (A1>=1)
else
   errordlg('DEBE INGRESAR VALORES NUMERICOS ENTEROS',' Curso_GUIDE ');
   ini=char(' ');
   set(handles.amp_uno,'String',ini);
end

function amp_uno_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function amp_dos_Callback(hObject, eventdata, handles)
global A2
A2=str2double(get(handles.amp_dos,'String'));
if (A2>=1)
else
    errordlg('DEBE INGRESAR VALORES NUMERICOS ENTEROS',' Curso_GUIDE ');
    ini=char(' ');
    set(handles.amp_dos,'String',ini);
end

function amp_dos_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function frec_uno_Callback(hObject, eventdata, handles)
global A3
A3=str2double(get(handles.frec_uno,'String'));
if (A3>=1)
else
    errordlg('DEBE INGRESAR VALORES NUMERICOS ENTEROS',' Curso_GUIDE ');
    ini=char(' ');
    set(handles.frec_uno,'String',ini);
end

function frec_uno_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function frec_dos_Callback(hObject, eventdata, handles)
global A4
A4=str2double(get(handles.frec_dos,'String'));
if (A4>=1)
else
    errordlg('DEBE INGRESAR VALORES NUMERICOS ENTEROS',' Curso_GUIDE ');
    ini=char(' ');
    set(handles.frec_dos,'String',ini);
end


function frec_dos_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cinco_Callback(hObject, eventdata, handles)

function cinco_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function seis_Callback(hObject, eventdata, handles)

function seis_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function siete_Callback(hObject, eventdata, handles)

function siete_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ocho_Callback(hObject, eventdata, handles)

function ocho_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nueve_Callback(hObject, eventdata, handles)

function nueve_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function diez_Callback(hObject, eventdata, handles)

function diez_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton4_Callback(hObject, eventdata, handles)
hMod = modem.qammod('M',4,'SymbolOrder','Gray');
% Crear un diagrama de dispersión
scatterPlot = commscope.ScatterPlot('SamplesPerSymbol',1,'Constellation',hMod.Constellation);
% Mostrar constelación
scatterPlot.PlotSettings.Constellation = 'on';
scatterPlot.PlotSettings.ConstellationStyle = '.';
% Agregar etiquetas de símbolos
hold on;
k=log2(hMod.M);
for jj=1:hMod.M
        text(real(hMod.Constellation(jj))+0.15,...,
        imag(hMod.Constellation(jj)),...
        dec2base(hMod.SymbolMapping(jj),2,k));
end
hold off;

function pushbutton8_Callback(hObject, eventdata, handles)
hMod = modem.qammod('M',8,'SymbolOrder','Gray');
scatterPlot = commscope.ScatterPlot('SamplesPerSymbol',1,'Constellation',hMod.Constellation);
scatterPlot.PlotSettings.Constellation = 'on';
scatterPlot.PlotSettings.ConstellationStyle = '.';
hold on;
k=log2(hMod.M);
for jj=1:hMod.M
        text(real(hMod.Constellation(jj))+0.15,...,
        imag(hMod.Constellation(jj)),...
        dec2base(hMod.SymbolMapping(jj),2,k));
end
hold off;

function pushbutton16_Callback(hObject, eventdata, handles)
hMod = modem.qammod('M',16,'SymbolOrder','Gray');
scatterPlot = commscope.ScatterPlot('SamplesPerSymbol',1,'Constellation',hMod.Constellation);
scatterPlot.PlotSettings.Constellation = 'on';
scatterPlot.PlotSettings.ConstellationStyle = '.';
hold on;
k=log2(hMod.M);
for jj=1:hMod.M
        text(real(hMod.Constellation(jj))+0.15,...,
        imag(hMod.Constellation(jj)),...
        dec2base(hMod.SymbolMapping(jj),2,k));
end
hold off;

function pushbutton32_Callback(hObject, eventdata, handles)
hMod = modem.qammod('M',32,'SymbolOrder','Gray');
scatterPlot = commscope.ScatterPlot('SamplesPerSymbol',1,'Constellation',hMod.Constellation);
scatterPlot.PlotSettings.Constellation = 'on';
scatterPlot.PlotSettings.ConstellationStyle = '.';
hold on;
k=log2(hMod.M);
for jj=1:hMod.M
        text(real(hMod.Constellation(jj))+0.15,...,
        imag(hMod.Constellation(jj)),...
        dec2base(hMod.SymbolMapping(jj),2,k));
end
hold off;

function pushbutton64_Callback(hObject, eventdata, handles)
hMod = modem.qammod('M',64,'SymbolOrder','Gray');
scatterPlot = commscope.ScatterPlot('SamplesPerSymbol',1,'Constellation',hMod.Constellation);
scatterPlot.PlotSettings.Constellation = 'on';
scatterPlot.PlotSettings.ConstellationStyle = '.';
hold on;
k=log2(hMod.M);
for jj=1:hMod.M
        text(real(hMod.Constellation(jj))+0.15,...,
        imag(hMod.Constellation(jj)),...
        dec2base(hMod.SymbolMapping(jj),2,k));
end
hold off;

function pushbutton128_Callback(hObject, eventdata, handles)
hMod = modem.qammod('M',128,'SymbolOrder','Gray');
scatterPlot = commscope.ScatterPlot('SamplesPerSymbol',1,'Constellation',hMod.Constellation);
scatterPlot.PlotSettings.Constellation = 'on';
scatterPlot.PlotSettings.ConstellationStyle = '.';
hold on;
k=log2(hMod.M);
for jj=1:hMod.M
        text(real(hMod.Constellation(jj))+0.15,...,
        imag(hMod.Constellation(jj)),...
        dec2base(hMod.SymbolMapping(jj),2,k));
end
hold off;

function demu_qam_Callback(hObject, eventdata, handles)
QAM_mod_demod;
receiver_image_analyze;
