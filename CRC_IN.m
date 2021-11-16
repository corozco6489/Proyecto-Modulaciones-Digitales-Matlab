function varargout = CRC_IN(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CRC_IN_OpeningFcn, ...
                   'gui_OutputFcn',  @CRC_IN_OutputFcn, ...
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

function CRC_IN_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
handles.output = hObject;
guidata(hObject, handles);

function varargout = CRC_IN_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function ejemplodeteccion_Callback(hObject, eventdata, handles)
CRC_PRO;
