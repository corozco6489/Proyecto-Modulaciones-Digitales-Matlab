function varargout = ARQ_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ARQ_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ARQ_GUI_OutputFcn, ...
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

function ARQ_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
set(handles.axes1,'Visible','off');
handles.output = hObject;
guidata(hObject, handles);

function varargout = ARQ_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function procesar_Callback(hObject, eventdata, handles)
clc;
n=10;
set(handles.text1,'string',[ '[  ',num2str(n),'  ]']);
m=2;
set(handles.text4,'string',[ '[  ',num2str(m),'  ]']);
x=randi([0,1],m,n);
% Codificación de verificación de redundancia cíclica

div=[1 0 0 1];  
   set(handles.axes1); 
   axes(handles.axes1);
for i=1:m
    [q,r]=deconv(x(i,:),div); 
   y(i,:)=[x(i,:),zeros(1,3)];
   for k=1:n
           r(k)=mod(r(k),2);
   end
   fcs=[zeros(1,3),r];   
   pac(i,:)=bitxor(y(i,:),fcs);
   
   subplot(m,1,i); 
   bar(pac(i,:),0.5,'stacked'),colormap(cool);
   clear r;clear rem;
end
xlabel('Datos codificados con CRC');

% Codificación cíclica de datos
gen=cyclpoly(15,n+3,'min');
pac2=encode(pac,15,n+3,'cyclic',gen);
for i=1:m
   subplot(m,1,i); 
   bar(pac2(i,:),0.5,'stacked'),colormap(cool);
end
xlabel('Transmisión de datos codificados cíclicos');

% Transmisión de paquetes a través de un canal simétrico binario
pe=0.01;
z=1;flag=0;nt=0;
while(flag==0)
figure
for k=z:m

    rcvdata(k,:)=bsc(pac2(k,:),pe);   % datos: paquetes recibidos después de bsc Tx 
    subplot(m,1,k); bar(rcvdata(k,:),0.5,'stacked'),colormap(cool);
    nt=nt+1;
end
xlabel('Paquetes de datos recibidos');

figure
%Corrección de errores mediante decodificación cíclica
rcvdata2=decode(rcvdata,15,n+3,'cyclic',gen);
for k=z:m
subplot(m,1,k); bar(rcvdata2(k,:),0.5,'stacked'),colormap(cool);
end
xlabel('Datos después de decodificar');

err = 1;
for i=1:m
    [q2,r2]=deconv(rcvdata2(i,:),div);
           r2(1,:)=mod(r2(1,:),2);
    if r2==0
        err(1,i)=0;
    else
        err(1,i)=1;
    end
end
display(err);   % esto muestra el paquete en error

    for z=1:m+1
       if(z==m+1)
           break;
       elseif err(1,z)==1
                 break;
       end
   
    end

if z==m+1
    display(' TRANSMISIÓN EXITOSA');
    fprintf('Numero total de paquetes enviados: %d\n',nt);
    flag=1;
    break;
else
    display('Se requiere retransmisión');
end
end