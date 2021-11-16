function varargout = QAM_mod_demod_tx_gui(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @QAM_mod_demod_tx_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @QAM_mod_demod_tx_gui_OutputFcn, ...
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

function QAM_mod_demod_tx_gui_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
%Inicio
global binaryImgVector
%Valor de M array para la modulación QAM
M = 4;
nbit=length(binaryImgVector); % cantidad de bits de información
msg=binaryImgVector;
%Representación de la transmisión de información binaria como señal digital
x=msg;
etiqueta=num2str(x);
set(handles.text_tx_bits,'string',[ '[ ',etiqueta,' ]']);
bp=.000001; % bit period
bit=[]; 
for n=1:1:length(x)
    if x(n)==1;
       se=ones(1,100);
    else x(n)==0;
        se=zeros(1,100);
    end
     bit=[bit se];
end
t1=bp/100:bp/100:100*length(x)*(bp/100);
set(handles.axes1); 
axes(handles.axes1);
plot(t1,bit,'lineWidth',2.5);grid on;
axis([ 0 bp*length(x) -.5 1.5]);
ylabel('amplitude(volt)');
xlabel(' time(sec)');
title('Transmitiendo información como señal digital');

% La información binaria se convierte en forma simbólica para la modulación QAM M-array
M=M; % orden de modulación QAM
msg_reshape=reshape(msg,log2(M),nbit/log2(M))';
size(msg_reshape);
for(j=1:1:nbit/log2(M))
   for(i=1:1:log2(M))
       a(j,i)=num2str(msg_reshape(j,i));
   end
end
as=bin2dec(a);
ass=as';

set(handles.axes2); 
axes(handles.axes2);
stem(ass,'Linewidth',2.0);
title('Símbolo de la serie para la modulación QAM en el transmisor');
xlabel('n(discrete time)');
ylabel(' magnitude');

handles.output = hObject;
guidata(hObject, handles);

function varargout = QAM_mod_demod_tx_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function mod_qam_Callback(hObject, eventdata, handles)

QAM_mod_demod_medio_gui;
