function varargout = PSK_mod_demod_rx_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PSK_mod_demod_rx_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @PSK_mod_demod_rx_gui_OutputFcn, ...
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

function PSK_mod_demod_rx_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes1,'Visible','off');
%Inicio
global m bp f BinaryinformationReciver
t2=bp/99:bp/99:bp;                 
ss=length(t2);
%Demodulación binaria PSK
mn=[];
for n=ss:ss:length(m)
  t=bp/99:bp/99:bp;
  y=cos(2*pi*f*t); 
  mm=y.*m((n-(ss-1)):n);
  t4=bp/99:bp/99:bp;
  z=trapz(t4,mm)
  zz=round((2*z/bp))                                     
  if(zz>0)  % logic level = (A+A)/2=0 
            % A*cos(2*pi*f*t+pi) means -A*cos(2*pi*f*t)
    a=1;
  else
    a=0;
  end
  mn=[mn a];
end
BinaryinformationReciver=mn;
%Representación de información binaria como señal digital que se logra después de la demodulación de PSK
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
title('Información recibida - Señal digital después de la demodulación binaria PSK');
etiqueta=num2str(BinaryinformationReciver);
set(handles.text_tx_bits,'string',[ '[ ',etiqueta,' ]']);
handles.output = hObject;
guidata(hObject, handles);

function varargout = PSK_mod_demod_rx_gui_OutputFcn(hObject, eventdata, handles) 
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
