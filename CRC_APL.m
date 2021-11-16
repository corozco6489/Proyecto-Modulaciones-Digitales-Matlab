function varargout = CRC_APL(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CRC_APL_OpeningFcn, ...
                   'gui_OutputFcn',  @CRC_APL_OutputFcn, ...
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

function CRC_APL_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
handles.output = hObject;
guidata(hObject, handles);

function varargout = CRC_APL_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function dat_Callback(hObject, eventdata, handles)

function dat_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function CalcCRC_Callback(hObject, eventdata, handles)
data=get(handles.dat, 'String')   
A = strread(data,'%u')    
B=A'                      
Divisor=get(handles.divisor, 'String')
C= strread(Divisor,'%u')
D=C'
if (length(B)==7 && length(D)==5)
crc=mycrc(B,D,1)  
result=[B,crc]
set(handles.reslt,'String',...
    num2str(result))           

set(handles.InfoBox,'String',...
    ['Result : ',...
num2str(result),'  '])           
else
    set(handles.InfoBox,'String',...
    ['Los datos deben ser de 7 bits y el divisor debe ser de 5 bits.'])        
end

function reslt_Callback(hObject, eventdata, handles)

function reslt_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function VerifCRC_Callback(hObject, eventdata, handles)
data=get(handles.reslt, 'String')
A = strread(data,'%u')           
B=A'                            
Divisor=get(handles.divisor, 'String')
C= strread(Divisor,'%u')
D=C'
check=mycrc(B,D,2)
if check==[1]
set(handles.InfoBox,'String',[get(handles.InfoBox,'String'),'CRC chequeo exitoso'])
end
if check~=[1]
set(handles.InfoBox,'String',[get(handles.InfoBox,'String'),'CRC verificación fallida, los datos se corrompieron en el camino'])
end

function InfoBox_ButtonDownFcn(hObject, eventdata, handles)

function RandmDatGen_Callback(hObject, eventdata, handles)
R = rand(1,7)
Y = round(R)
set(handles.dat, 'String',...
num2str(Y))

function divisor_Callback(hObject, eventdata, handles)

function divisor_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function x=mycrc(data,divisor,type)
if ((type==1)||(type==2))
    n=length(divisor)
    appender=[0 0 0 0]
    dividend=[data]
    if ((type==1))
        dividend=[data,appender]
    end
    dividendA=dividend(1:5)
    dividendB=dividend(6:length(dividend))
    result=dividendA
    while((n-1)~=length(result))
        result=bitxor(result,divisor)
        while(result(1)==0 && ((n-1)~=length(result)))
            result=result(2:length(result))
            if ((length(result)<length(divisor)) && (length(dividendB)~=0))
                result=[result,dividendB(1)]
                dividendB=dividendB(2:length(dividendB))
            end
        end
    end

    x=result

    if (type==2 & result==zeros(size(result)))
        x=[1];
        disp('chequeo exitoso, datos no corrompidos')
    elseif (type==2)
        x=[0]
        disp('comprobar que los datos fallidos están dañados')
    end

else
    disp('el tipo inválido ingresado en el tercer parámetro debe ser 1 o 2')
end

