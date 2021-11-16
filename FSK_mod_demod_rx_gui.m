function varargout = FSK_mod_demod_rx_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FSK_mod_demod_rx_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @FSK_mod_demod_rx_gui_OutputFcn, ...
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

function FSK_mod_demod_rx_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes1,'Visible','off');
%Inicio
global A m bp f1 f2 BinaryinformationReciver
t2=bp/99:bp/99:bp;                 
ss=length(t2);
%Demodulación binaria FSK 
mn=[];
for n=ss:ss:length(m)
  t=bp/99:bp/99:bp;
  y1=cos(2*pi*f1*t); % señal portadora para información 1
  y2=cos(2*pi*f2*t); % señal portadora para información 0
  mm=y1.*m((n-(ss-1)):n);
  mmm=y2.*m((n-(ss-1)):n);
  t4=bp/99:bp/99:bp;
  z1=trapz(t4,mm)
  z2=trapz(t4,mmm) 
  zz1=round(2*z1/bp)
  zz2= round(2*z2/bp)
  if(zz1>A/2)  % logic lavel = (0+A)/2 or (A+0)/2 or 2.5
    a=1;
  else(zz2>A/2)
    a=0;
  end
  mn=[mn a];
end
BinaryinformationReciver=mn;
%Representación de información binaria como señal digital que se logra después de la demodulación.
bit=[];
for n=1:length(mn);
    if mn(n)==1;
       se=ones(1,100);
    else mn(n)==0;
        se=zeros(1,100);
    end
     bit=[bit se];
end
t4=bp/100:bp/100:100*length(mn)*(bp/100);
set(handles.axes1); 
axes(handles.axes1);
plot(t4,bit,'LineWidth',2.5);grid on;
axis([ 0 bp*length(mn) -.5 1.5]);
ylabel('amplitude(volt)');
xlabel(' time(sec)');
title('Información recibida - Señal digital después de la demodulación binaria FSK');
etiqueta=num2str(BinaryinformationReciver);
set(handles.text_tx_bits,'string',[ '[ ',etiqueta,' ]']);
handles.output = hObject;
guidata(hObject, handles);

function varargout = FSK_mod_demod_rx_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function edit_tx_bits_Callback(hObject, eventdata, handles)
input = str2num(get(hObject,'String'));
if (isempty(input))
     set(hObject,'String','0')
end

function edit_tx_bits_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tx_calcular_Callback(hObject, eventdata, handles)

receiver_image_analyze;
