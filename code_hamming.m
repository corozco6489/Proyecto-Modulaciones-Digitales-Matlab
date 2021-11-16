function varargout = code_hamming(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @code_hamming_OpeningFcn, ...
                   'gui_OutputFcn',  @code_hamming_OutputFcn, ...
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

function code_hamming_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
handles.output = hObject;
guidata(hObject, handles);

function varargout = code_hamming_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Calcula bits de paridad y los inserta en los lugares correctos
function E=insert_parity_bits(message,nbp)
nbp=nbp;
A=message;
E=insert_parity_spots(A,nbp);
P=generate_hamming_matrix(E,nbp);
%Encuentra puntos en la cadena del mensaje donde los bits son = 1
for V=1:nbp
    Q(V,:)=P(V,:).*E;
end
Q;
%Para cada línea de paridad, encuentra si la suma de bits que son 1 es par (0) o impar (1)
for U=1:nbp
    R(U,:)=mod(length(find(Q(U,:))),2);
end
R;
%Agrega los bits de paridad necesarios en el mensaje.
for S=0:nbp-1
    E(1,2^S)=R(S+1,1);
end
E;

% El rol de esta función es insertar ceros (0) en los puntos donde la paridad
% bits serán
function E=insert_parity_spots(message,nbp)
clearvars D E
nb_bits_parity=nbp;
D=message;
E=ones(1,length(D)+nb_bits_parity);
for I=0:nb_bits_parity
    E(1,2^I)=0;
    E=E(1,1:length(D)+nb_bits_parity);
end
E;
for M=1:length(E)  
    if E(1,M)==1     
        count=floor(log2(M)+1);
        E(1,M)=D(1,M-count);   
    end
end
E;

function P=generate_hamming_matrix(coded_message,nbp)
P=zeros(nbp,length(coded_message));
stop_z=length(P);
for X=1:nbp
    for Y=0:length(P)-1
        
        if Y<stop_z/2^X
           P(X,((2^X)*Y+2^(X-1)):((2^X)*Y+(2^X)-1))=1;
        end
        
    end     
end
P=P(:,1:stop_z);

function pushbutton1_Callback(hObject, eventdata, handles)
message = get(handles.edit1,'String');
message = str2num(message);
x=message;
bp=.000001; 
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
ylabel('amplitude');
xlabel(' time(seg)');
title('Transmitiendo información como señal digital');
%Cadena binaria
n=length(message);
nbp=floor(log2(n+ceil(log2(n))))+1;      
%Añadimos bits de paridad. Así se ve el mensaje que enviamos.
sent_message=insert_parity_bits(message,nbp)
set(handles.text1,'string',[ '[  ',num2str(sent_message),'  ]']);
%Un bit aleatorio se invierte durante la transmisión del mensaje.
received_message=sent_message;

%Se inserta un error en el mensaje.
rnd_pos=round(rand*length(received_message)-0.5);
received_message(1,rnd_pos)=mod(received_message(1,rnd_pos)-1,2)

%error_check() inicia la función de comprobación de errores
vect_error=error_check(received_message,nbp);

%find_error() devuelve la Posición del error.
pos_err=find_error(received_message,nbp);
set(handles.text8,'string',[ '[  ',num2str(pos_err),'  ]']);

%Corregimos el error.
%correct_message() corrige el error
corrected_message=correct_message(received_message,nbp)
set(handles.text12,'string',[ '[  ',num2str(corrected_message),'  ]']);

%Eliminamos los bits de paridad.
%message_decode() elimina los bits de paridad para revelar la cadena original
message_final=message_decode(corrected_message,nbp);
set(handles.text10,'string',[ '[  ',num2str(message_final),'  ]']);
y=message_final;
bp=.000001; 
bitf=[]; 
for n=1:1:length(y)
    if y(n)==1;
       sef=ones(1,100);
    else y(n)==0;
        sef=zeros(1,100);
    end
     bitf=[bitf sef];
end
t2=bp/100:bp/100:100*length(y)*(bp/100);
set(handles.axes2); 
axes(handles.axes2);
plot(t2,bitf,'lineWidth',2.5);grid on;
axis([ 0 bp*length(y) -.5 1.5]);
ylabel('amplitude');
xlabel(' time(seg)');
title('Información recibida como señal digital');

% comprobación de errores
% extrae bits de paridad y comprueba si hay errores
function R=error_check(received_message,nbp)
O=received_message;
P=generate_hamming_matrix(O,nbp);
%Encuentra posiciones donde la cadena de mensajes = 1
for V=1:nbp
    T(V,:)=P(V,:).*O(1,:);
end
%Calcula si la suma de unos para cada línea de paridad es par (0) o impar (1)
for U=1:nbp
    R(U,:)=mod(length(find(T(U,:))),2);
end
R;
flag=isequal(R,zeros(length(R),1));
if flag==1
    disp('no error')
else
    disp('Error encontrado')
end

% buscador de errores
% compara la matriz de Hamming con el vector de error R para averiguar qué bit es
% erróneo
function b=find_error(message_received,nbp)
Y=message_received;
P=generate_hamming_matrix(Y,nbp);
R=error_check(Y,nbp);
for b=1:length(P)
    c=isequal(R(:,1),P(:,b));
    if c==1
        R;
        P(:,b);
        bit=b;
        disp('Error en bit')
        disp(b)
        break
    end
end

%corrige un bit erróneo
function a=correct_message(message_received,nbp)  
d=message_received;
error_pos=find_error(message_received, nbp);
a=d;
a(1,error_pos)=mod(d(1,error_pos)+1,2);

%elimina los bits de paridad del mensaje corregido
function g=message_decode(message_recu,nbp)
t=message_recu;
v=ones(1,length(t));
for I=0:nbp-1
    v(1,2^I)=0;
end
g=t(1,[find(v)]);
