function varargout = CRC_PRO(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CRC_PRO_OpeningFcn, ...
                   'gui_OutputFcn',  @CRC_PRO_OutputFcn, ...
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

function CRC_PRO_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
handles.output = hObject;
guidata(hObject, handles);

function varargout = CRC_PRO_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function calcular_Callback(hObject, eventdata, handles)
error=get(handles.error,'Value');
n=7;
set(handles.text1,'string',[ '[  ',num2str(n),'  ]']);
k=4;
set(handles.text3,'string',[ '[  ',num2str(k),'  ]']);
m1=str2num(get(handles.edit1,'String'));   
m2=str2num(get(handles.edit2,'String'));   
m3=str2num(get(handles.edit3,'String')); 
m4=str2num(get(handles.edit4,'String'));  
mens=[m1 m2 m3 m4];
if((m1~=0) && (m1~=1)) || ((m2~=0) && (m2~=1)) || ((m3~=0)&& (m3~=1)) || ((m4~=0) && (m4~=1))        
errordlg('Introduzca números binarios',' Palabra Fuente ');
end

pol_gen = cyclpoly(n,k,'min');
c = mod(conv(pol_gen,mens),2);

if error==1
e=[randerr(1,k) zeros(1,n-k)];   
r=bitxor(c,e);   
pos=find(e);
set(handles.text2,'Visible','on');   
set(handles.text_e,'String',num2str(pos));
else
r=c;
set(handles.text2,'Visible','off');   
set(handles.text_e,'String','');
end
[q res]=deconv(r,pol_gen);
s=mod(abs(res),2);
set(handles.text_g,'String',num2str(pol_gen));
set(handles.text_c,'String',num2str(r));
set(handles.text_s,'String',num2str(s));
guidata(hObject, handles);

function error_Callback(hObject, eventdata, handles)

function edit1_Callback(hObject, eventdata, handles)

function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupmenu_variables_Callback(hObject, eventdata, handles)

function popupmenu_variables_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
