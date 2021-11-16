function varargout = pcm_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pcm_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @pcm_gui_OutputFcn, ...
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

function pcm_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.axes3,'Visible','off');
set(handles.axes4,'Visible','off');
set(handles.axes5,'Visible','off');
set(handles.axes6,'Visible','off');
handles.output = hObject;
guidata(hObject, handles);

function varargout = pcm_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pcm_proceso_Callback(hObject, eventdata, handles)
% CODIFICACIÓN PCM
f = 2;
set(handles.text4,'string',[ '[  ',num2str(f),'  ]']);
fs = 20;
set(handles.text5,'string',[ '[  ',num2str(fs),'  ]']);
Ts = 1/fs;
var=strcat(' Ts = ',num2str(Ts),' (seg) ');
set(handles.ts,'String',num2str(var));

fss = 1.e4;
Tss = 1/fss;

t = 0:Tss:2-Tss;
d = Ts/40:Ts:2+Ts/40;

p = pulstran(t,d,'rectpuls',1/(fs*40));
% Señal de mensaje analógica
m = sin(2*pi*f*t)+1.1;
% Señal muestreada
ms = m.*p;
% Mensaje cuantificado
qm = quant(ms,2/16);
em = 8*(qm);

% MENSAJE DE CODIFICACIÓN
j = 1;
for i=1:length(em)
    if ((((i>1)&&(em(i)~=em(i-1)))||(i==1))&&(em(i)~=0))
        x(j) = em(i)-1;
        j=j+1;
    end
end

z = dec2bin(x,5);
z = z';
z = z(:);
z = str2num(z);

s = 2*(z')-1;

Tb = 2/length(s);
fb = 0.5/Tb;
BL = Tb/Tss;
y = ones(BL,1);
bit = 5*y*s;
bit = bit(:);
bit = bit'; % Flujo de bits Polar NRZ

% DECODIFICACIÓN PCM
rb = bit(ceil(Tb/(Tss)):(Tb/Tss):length(bit));
rb = (rb+5)/10;
l = length(rb);

for i = 1:l/5
    q = rb((5*i)-4:5*i);
    q = num2str(q);
    x1(i) = bin2dec(q);
    e(i) = x1(i)+1;
end

e = e/8;

y1 = ones(1,ceil((Ts/40)/Tss));
y2 = zeros(1,(Ts/Tss)-length(y1));
y3 = [y1 y2];
y3 = y3';

ms1 = y3*e; % Señal muestreada de señal codificada
ms1 = ms1(:);

% Filtrado de la señal muestreada

[n,w] = buttord(f/fss,(f+1)/fss,.6,4);
[a,b] = butter(n,w,'low');
rm = filter(a,b,ms1);
rm = rm*50;% Señal original recibida


% Trazado de señales
set(handles.axes1); 
axes(handles.axes1);
plot(t,m,'b',t,ms,'r');
legend('Mensaje analógico','Mensaje muestreado')
grid;
xlabel('time(seg)');
ylabel('Amplitude');
axis([0 2 0 2.25]);

set(handles.axes2); 
axes(handles.axes2);
plot(t,ms,'k',t,qm,'r');
legend('Mensaje muestreado','Mensaje cuantificado')
grid;
xlabel('time(seg)');
ylabel('Amplitude');
axis([0 2 0 2.25]);

set(handles.axes3); 
axes(handles.axes3);
plot(t,em,'b')
xlabel('time(seg)');
ylabel('Amplitude');
title('Mensaje nivelado');
grid;
axis([0 2 -0.5 16.5]);

set(handles.axes4); 
axes(handles.axes4);
plot(t,bit,'k')
xlabel('time(seg)');
ylabel('Amplitude');
title('POLAR NRZ CODIFICADO');
grid;
axis([0 2 -5.25 5.25]);

set(handles.axes5); 
axes(handles.axes5);
plot(t,ms1,'b');
title('Mensaje muestreado recuperado')
grid;
xlabel('time(seg)');
ylabel('Amplitude');
axis([0 2 0 2.25]);

set(handles.axes6); 
axes(handles.axes6);
plot(t,rm,'b');
title('Mensaje analógico recuperado')
grid;
xlabel('time(seg)');
ylabel('Amplitude');
axis([0 2 0 2.25]);
