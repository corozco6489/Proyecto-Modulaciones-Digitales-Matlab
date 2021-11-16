function varargout = CRC_GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CRC_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CRC_GUI_OutputFcn, ...
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

function CRC_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
movegui('center');
handles.output = hObject;
guidata(hObject, handles);

function varargout = CRC_GUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function pushbutton1_Callback(hObject, eventdata, handles)
CRC_IN;

function crc_apl_Callback(hObject, eventdata, handles)
CRC_APL;
