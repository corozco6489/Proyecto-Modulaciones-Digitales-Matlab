function varargout = tdm(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tdm_OpeningFcn, ...
                   'gui_OutputFcn',  @tdm_OutputFcn, ...
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

function tdm_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
im1=imread('td1.png');
axes(handles.axes5);
imshow(im1);
set(handles.axes4,'Visible','off');
handles.output = hObject;
guidata(hObject, handles);

function varargout = tdm_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function edit_x1_Callback(hObject, eventdata, handles)

function edit_x1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_x2_Callback(hObject, eventdata, handles)

function edit_x2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_x3_Callback(hObject, eventdata, handles)

function edit_x3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function tdm_calcular_Callback(hObject, eventdata, handles)
clc
x1=str2num(get(handles.edit_x1,'string'));
x2=str2num(get(handles.edit_x2,'string'));
x3=str2num(get(handles.edit_x3,'string'));
set(handles.axes_x1,'visible','on')
set(handles.axes_x2,'visible','on')
set(handles.axes_x3,'visible','on')
x=[x1;x2;x3];
[r c]=size(x);
k=0;
% Multiplexing
for i=1:c
    for j=1:r
    k=k+1;
    y(k)=x(j,i);
    end
end
% Graficado
color='ybrgmkc';
sig='x1';
for i=1:r
    sig(2)=i+48;
    j=mod(i,7)+1;
    if i==1
        axes(handles.axes_x1)
    elseif i==2
        axes(handles.axes_x2)
    elseif i==3
        axes(handles.axes_x3)
    end
    stem(x(i,:),color(j),'linewidth',1)
    title(sig)
    ylabel('Amplitude')
    grid
end
xlabel('Time')
t=1/r:1/r:c;
axes(handles.axes4)
for i=1:r
  j=mod(i,7)+1;
  stem(t(i:r:r*c),y(i:r:r*c),color(j),'linewidth',1)
  hold on
  grid
end
hold off
title('Secuencia multiplexada por división de tiempo')
xlabel('Time')
ylabel('Amplitude')
