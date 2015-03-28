function varargout = polydraw(varargin)
% POLYDRAW M-file for polydraw.fig
%      POLYDRAW, by itself, creates a new POLYDRAW or raises the existing
%      singleton*.
%
%      H = POLYDRAW returns the handle to a new POLYDRAW or the handle to
%      the existing singleton*.
%
%      POLYDRAW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POLYDRAW.M with the given input arguments.
%
%      POLYDRAW('Property','Value',...) creates a new POLYDRAW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before polydraw_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to polydraw_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help polydraw

% Last Modified by GUIDE v2.5 08-Aug-2007 09:08:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @polydraw_OpeningFcn, ...
                   'gui_OutputFcn',  @polydraw_OutputFcn, ...
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
% End initialization code - DO NOT EDIT


% --- Executes just before polydraw is made visible.
function polydraw_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to polydraw (see VARARGIN)

% Choose default command line output for polydraw
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes polydraw wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = polydraw_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

LastPoint = get(hObject, 'UserData');
Point = get(hObject, 'CurrentPoint');

%Point
%LastPoint
set(hObject, 'UserData', Point);

Poly = get(handles.edit1, 'UserData');
Poly = [Poly; Point(1, 1:2)];

hold on
plot(Point(1,1), Point(1, 2), 'bo');
if length(LastPoint) > 0
    %plot(hObject, [Poly(:, 1);Poly(1,1)], [Poly(:, 2);Poly(1, 2)]);
    plot(hObject, [LastPoint(1,1);Point(1,1)], [LastPoint(1, 2);Point(1,2)]);
end
set(handles.edit1, 'UserData', Poly);
set(handles.edit1, 'String', mat2str(Poly));

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Poly = get(handles.edit1, 'String');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit1, 'String', []);
set(handles.edit1, 'UserData', []);
set(handles.axes1, 'UserData', []);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%im = imread('../shortestpath/testi.png')
%imagesc(im)


