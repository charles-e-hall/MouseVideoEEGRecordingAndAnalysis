function varargout = MouseAnalysisTool(varargin)
% MOUSEANALYSISTOOL MATLAB code for MouseAnalysisTool.fig
%      MOUSEANALYSISTOOL, by itself, creates a new MOUSEANALYSISTOOL or raises the existing
%      singleton*.
%
%      H = MOUSEANALYSISTOOL returns the handle to a new MOUSEANALYSISTOOL or the handle to
%      the existing singleton*.
%
%      MOUSEANALYSISTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOUSEANALYSISTOOL.M with the given input arguments.
%
%      MOUSEANALYSISTOOL('Property','Value',...) creates a new MOUSEANALYSISTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MouseAnalysisTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MouseAnalysisTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MouseAnalysisTool

% Last Modified by GUIDE v2.5 12-Jul-2017 14:38:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MouseAnalysisTool_OpeningFcn, ...
                   'gui_OutputFcn',  @MouseAnalysisTool_OutputFcn, ...
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


% --- Executes just before MouseAnalysisTool is made visible.
function MouseAnalysisTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MouseAnalysisTool (see VARARGIN)

% Choose default command line output for MouseAnalysisTool
handles.output = hObject;
handles.progress = waitbar(0, 'Initializing ...');
global state
state.m1.times = zeros(1,6);
state.m1.class = [];
state.m1.inject = zeros(1,6);
state.m2.times = zeros(1,6);
state.m2.class = [];
state.m2.inject = zeros(1,6);
state.m3.times = zeros(1,6);
state.m3.class = [];
state.m3.inject = zeros(1,6);
state.m4.times = zeros(1,6);
state.m4.class = [];
state.m4.inject = zeros(1,6);
state.m5.times = zeros(1,6);
state.m5.class = [];
state.m5.inject = zeros(1,6);
%load('StandardModelforMouseSE.mat');
% try
%     state.cam = webcam;
% catch
%     warndlg('Please Connect a Webcam');
%     state.cam = [];
% end    
waitbar(0.25, handles.progress, 'Connecting to webcam ...');

try
    state.cam = webcam;
catch ME
    %NoWebcam = MException('KASE:NoWebcam', 'Unable to Connect to Webcam');
%     fID = fopen('ErrorList.txt', 'a+');
%     time = clock;
%     fprintf(fID, '%d %d %d %d %d %d\n', time);
%     fprintf(fID, 'Unable to connect to Webcam\n');
%     fclose(fID);
    sendErrorEmail(ME);
    % throw(NoWebcam);
end

waitbar(0.5, handles.progress, 'Checking for Updates ...');
if ispc
    Y = dos('ping -n 1 8.8.8.8');
else
    Y = dos('ping -c 1 8.8.8.8');
end

if Y~=0
%     NoInternet = MException('KASE:NoInternet', 'Please connect to the internet');
%     fID = fopen('ErrorList.txt', 'a+');
%     time = clock;
%     fprintf(fID, '%d %d %d %d %d %d\n', time);
%     fprintf(fID, 'No Internet Connection During Startup\n');
%     fclose(fID);
    sendErrorEmail(ME);
    %throw(NoInternet);
    %errordlg('Please Connect to the Internet');
end

waitbar(1, handles.progress, 'Finalizing Setup ...');
close(handles.progress);
    
%Set initial Parameters
state.KAconc = 1;
state.infusionRate = 0.333; %In milliliters per minute.
state.acqRate = 10;

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes MouseAnalysisTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MouseAnalysisTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function m1Weight_Callback(hObject, eventdata, handles)
% hObject    handle to m1Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m1Weight as text
%        str2double(get(hObject,'String')) returns contents of m1Weight as a double
%set(handles.m1Vol,'String',num2str(((str2double(get(handles.m1Dose,'String')))*(str2double(get(handles.m1Weight,'String'))))));
global state
weight = str2double(get(handles.m1Weight, 'String'));
dose = str2double(get(handles.m1Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m1Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m1Weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m1Vol_Callback(hObject, eventdata, handles)
% hObject    handle to m1Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m1Vol as text
%        str2double(get(hObject,'String')) returns contents of m1Vol as a double
%set(handles.m1Vol,'String',num2str(((str2double(get(handles.m1Dose,'String')))*(str2double(get(handles.m1Weight,'String'))))));
global state
weight = str2double(get(handles.m1Weight, 'String'));
dose = str2double(get(handles.m1Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m1Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m1Vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2Weight_Callback(hObject, eventdata, handles)
% hObject    handle to m2Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m2Weight as text
%        str2double(get(hObject,'String')) returns contents of m2Weight as a double
%set(handles.m2Vol,'String',num2str(((str2double(get(handles.m2Dose,'String')))*(str2double(get(handles.m2Weight,'String'))))));
global state
weight = str2double(get(handles.m2Weight, 'String'));
dose = str2double(get(handles.m2Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m2Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m2Weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2Vol_Callback(hObject, eventdata, handles)
% hObject    handle to m2Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m2Vol as text
%        str2double(get(hObject,'String')) returns contents of m2Vol as a double
%set(handles.m2Vol,'String',num2str(((str2double(get(handles.m2Dose,'String')))*(str2double(get(handles.m2Weight,'String'))))));
global state
weight = str2double(get(handles.m2Weight, 'String'));
dose = str2double(get(handles.m2Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m2Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m2Vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3Weight_Callback(hObject, eventdata, handles)
% hObject    handle to m3Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m3Weight as text
%        str2double(get(hObject,'String')) returns contents of m3Weight as a double
%set(handles.m3Vol,'String',num2str(((str2double(get(handles.m3Dose,'String')))*(str2double(get(handles.m3Weight,'String'))))));
global state
weight = str2double(get(handles.m3Weight, 'String'));
dose = str2double(get(handles.m3Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m3Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m3Weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3Vol_Callback(hObject, eventdata, handles)
% hObject    handle to m3Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m3Vol as text
%        str2double(get(hObject,'String')) returns contents of m3Vol as a double
%set(handles.m3Vol,'String',num2str(((str2double(get(handles.m3Dose,'String')))*(str2double(get(handles.m3Weight,'String'))))));
global state
weight = str2double(get(handles.m3Weight, 'String'));
dose = str2double(get(handles.m3Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m3Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m3Vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m4Weight_Callback(hObject, eventdata, handles)
% hObject    handle to m4Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m4Weight as text
%        str2double(get(hObject,'String')) returns contents of m4Weight as a double
%set(handles.m4Vol,'String',num2str(((str2double(get(handles.m4Dose,'String')))*(str2double(get(handles.m4Weight,'String'))))));
global state
weight = str2double(get(handles.m4Weight, 'String'));
dose = str2double(get(handles.m4Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m4Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m4Weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m4Vol_Callback(hObject, eventdata, handles)
% hObject    handle to m4Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m4Vol as text
%        str2double(get(hObject,'String')) returns contents of m4Vol as a double
%set(handles.m4Vol,'String',num2str(((str2double(get(handles.m4Dose,'String')))*(str2double(get(handles.m4Weight,'String'))))));
global state
weight = str2double(get(handles.m4Weight, 'String'));
dose = str2double(get(handles.m4Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m4Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m4Vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m5Weight_Callback(hObject, eventdata, handles)
% hObject    handle to m5Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m5Weight as text
%        str2double(get(hObject,'String')) returns contents of m5Weight as a double
%set(handles.m5Vol,'String',num2str(((str2double(get(handles.m5Dose,'String')))*(str2double(get(handles.m5Weight,'String'))))));
global state
weight = str2double(get(handles.m5Weight, 'String'));
dose = str2double(get(handles.m5Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m5Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m5Weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m5Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m5Vol_Callback(hObject, eventdata, handles)
% hObject    handle to m5Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m5Vol as text
%        str2double(get(hObject,'String')) returns contents of m5Vol as a double
%set(handles.m5Vol,'String',num2str(((str2double(get(handles.m5Dose,'String')))*(str2double(get(handles.m5Weight,'String'))))));
global state
weight = str2double(get(handles.m5Weight, 'String'));
dose = str2double(get(handles.m5Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m5Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m5Vol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m5Vol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in m1Injection.
function m1Injection_Callback(hObject, eventdata, handles)
% hObject    handle to m1Injection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state

if ~sum(state.m1.inject)
    state.m1.inject = clock;
    set(handles.m1Injection, 'Enable', 'off');
else
    warndlg('You already injected this mouse.');
end


% --- Executes on button press in m2Injection.
function m2Injection_Callback(hObject, eventdata, handles)
% hObject    handle to m2Injection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state

if ~sum(state.m2.inject)
    state.m2.inject = clock;
    set(handles.m2Injection, 'Enable', 'off');
else
    warndlg('You already injected this mouse.');
end


% --- Executes on button press in m3Injection.
function m3Injection_Callback(hObject, eventdata, handles)
% hObject    handle to m3Injection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state

if ~sum(state.m3.inject)
    state.m3.inject = clock;
    set(handles.m3Injection, 'Enable', 'off');
else
    warndlg('You already injected this mouse.');
end


% --- Executes on button press in m4Injection.
function m4Injection_Callback(hObject, eventdata, handles)
% hObject    handle to m4Injection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state

if ~sum(state.m4.inject)
    state.m4.inject = clock;
    set(handles.m4Injection, 'Enable', 'off');
else
    warndlg('You already injected this mouse.');
end


% --- Executes on button press in m5Injection.
function m5Injection_Callback(hObject, eventdata, handles)
% hObject    handle to m5Injection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state

if ~sum(state.m5.inject)
    state.m5.inject = clock;
    set(handles.m5Injection, 'Enable', 'off');
else
    warndlg('You already injected this mouse.');
end


% --- Executes on button press in m1Record.
function m1Record_Callback(hObject, eventdata, handles)
% hObject    handle to m1Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
%Get seizure class
classStr = get(get(handles.buttongroupM1, 'SelectedObject'), 'String');
class = classLookup(classStr);
state.m1.class = [state.m1.class class];

%Disable seizure class buttongroup during recording
if strcmp(get(handles.m1Record, 'String'), 'Start')
    set(handles.m1ClassI, 'Enable', 'off');
    set(handles.m1ClassII, 'Enable', 'off');
    set(handles.m1ClassIII, 'Enable', 'off');
    set(handles.m1ClassIV, 'Enable', 'off');
    set(handles.m1ClassV, 'Enable', 'off');
    set(handles.m1ClassVI, 'Enable', 'off');
else
    set(handles.m1ClassI, 'Enable', 'on');
    set(handles.m1ClassII, 'Enable', 'on');
    set(handles.m1ClassIII, 'Enable', 'on');
    set(handles.m1ClassIV, 'Enable', 'on');
    set(handles.m1ClassV, 'Enable', 'on');
    set(handles.m1ClassVI, 'Enable', 'on');
end

%Switch button from start to stop and vice versa
if strcmp(get(handles.m1Record, 'String'), 'Start')
    set(handles.m1Record, 'String', 'Stop', 'BackgroundColor', 'red');
elseif strcmp(get(handles.m1Record, 'String'), 'Stop')
    set(handles.m1Record, 'String', 'Start', 'BackgroundColor', [0.94 0.94 0.94]);
else
    errordlg('There was a problem with renaming the record button');
end

state.m1.times = [state.m1.times; clock];


function class = classLookup(classStr)
if strcmp(classStr, 'Class I')
    class = 1;
elseif strcmp(classStr, 'Class II')
    class = 2;
elseif strcmp(classStr, 'Class III')
    class = 3;
elseif strcmp(classStr, 'Class IV')
    class = 4;
elseif strcmp(classStr, 'Class V')
    class = 5;
elseif strcmp(classStr, 'Class VI')
    class = 6;
else
    class = 7;
end





% --- Executes on button press in m2Record.
function m2Record_Callback(hObject, eventdata, handles)
% hObject    handle to m2Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
%Get seizure class
classStr = get(get(handles.buttongroupM2, 'SelectedObject'), 'String');
class = classLookup(classStr);
state.m2.class = [state.m2.class class];

%Disable seizure class buttongroup during recording
if strcmp(get(handles.m2Record, 'String'), 'Start')
    set(handles.m2ClassI, 'Enable', 'off');
    set(handles.m2ClassII, 'Enable', 'off');
    set(handles.m2ClassIII, 'Enable', 'off');
    set(handles.m2ClassIV, 'Enable', 'off');
    set(handles.m2ClassV, 'Enable', 'off');
    set(handles.m2ClassVI, 'Enable', 'off');
else
    set(handles.m2ClassI, 'Enable', 'on');
    set(handles.m2ClassII, 'Enable', 'on');
    set(handles.m2ClassIII, 'Enable', 'on');
    set(handles.m2ClassIV, 'Enable', 'on');
    set(handles.m2ClassV, 'Enable', 'on');
    set(handles.m2ClassVI, 'Enable', 'on');
end

%Switch button from start to stop and vice versa
if strcmp(get(handles.m2Record, 'String'), 'Start')
    set(handles.m2Record, 'String', 'Stop', 'BackgroundColor', 'red');
elseif strcmp(get(handles.m2Record, 'String'), 'Stop')
    set(handles.m2Record, 'String', 'Start', 'BackgroundColor', [0.94 0.94 0.94]);
else
    errordlg('There was a problem with renaming the record button');
end

state.m2.times = [state.m2.times; clock];



% --- Executes on button press in m3Record.
function m3Record_Callback(hObject, eventdata, handles)
% hObject    handle to m3Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
%Get seizure class
classStr = get(get(handles.buttongroupM3, 'SelectedObject'), 'String');
class = classLookup(classStr);
state.m3.class = [state.m3.class class];

%Disable seizure class buttongroup during recording
if strcmp(get(handles.m3Record, 'String'), 'Start')
    set(handles.m3ClassI, 'Enable', 'off');
    set(handles.m3ClassII, 'Enable', 'off');
    set(handles.m3ClassIII, 'Enable', 'off');
    set(handles.m3ClassIV, 'Enable', 'off');
    set(handles.m3ClassV, 'Enable', 'off');
    set(handles.m3ClassVI, 'Enable', 'off');
else
    set(handles.m3ClassI, 'Enable', 'on');
    set(handles.m3ClassII, 'Enable', 'on');
    set(handles.m3ClassIII, 'Enable', 'on');
    set(handles.m3ClassIV, 'Enable', 'on');
    set(handles.m3ClassV, 'Enable', 'on');
    set(handles.m3ClassVI, 'Enable', 'on');
end

%Switch button from start to stop and vice versa
if strcmp(get(handles.m3Record, 'String'), 'Start')
    set(handles.m3Record, 'String', 'Stop', 'BackgroundColor', 'red');
elseif strcmp(get(handles.m3Record, 'String'), 'Stop')
    set(handles.m3Record, 'String', 'Start', 'BackgroundColor', [0.94 0.94 0.94]);
else
    errordlg('There was a problem with renaming the record button');
end

state.m3.times = [state.m3.times; clock];


% --- Executes on button press in m4Record.
function m4Record_Callback(hObject, eventdata, handles)
% hObject    handle to m4Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
%Get seizure class
classStr = get(get(handles.buttongroupM4, 'SelectedObject'), 'String');
class = classLookup(classStr);
state.m4.class = [state.m4.class class];

%Disable seizure class buttongroup during recording
if strcmp(get(handles.m4Record, 'String'), 'Start')
    set(handles.m4ClassI, 'Enable', 'off');
    set(handles.m4ClassII, 'Enable', 'off');
    set(handles.m4ClassIII, 'Enable', 'off');
    set(handles.m4ClassIV, 'Enable', 'off');
    set(handles.m4ClassV, 'Enable', 'off');
    set(handles.m4ClassVI, 'Enable', 'off');
else
    set(handles.m4ClassI, 'Enable', 'on');
    set(handles.m4ClassII, 'Enable', 'on');
    set(handles.m4ClassIII, 'Enable', 'on');
    set(handles.m4ClassIV, 'Enable', 'on');
    set(handles.m4ClassV, 'Enable', 'on');
    set(handles.m4ClassVI, 'Enable', 'on');
end

%Switch button from start to stop and vice versa
if strcmp(get(handles.m4Record, 'String'), 'Start')
    set(handles.m4Record, 'String', 'Stop', 'BackgroundColor', 'red');
elseif strcmp(get(handles.m4Record, 'String'), 'Stop')
    set(handles.m4Record, 'String', 'Start', 'BackgroundColor', [0.94 0.94 0.94]);
else
    errordlg('There was a problem with renaming the record button');
end

state.m4.times = [state.m4.times; clock];


% --- Executes on button press in m5Record.
function m5Record_Callback(hObject, eventdata, handles)
% hObject    handle to m5Record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state
%Get seizure class
classStr = get(get(handles.buttongroupM5, 'SelectedObject'), 'String');
class = classLookup(classStr);
state.m5.class = [state.m5.class class];

%Disable seizure class buttongroup during recording
if strcmp(get(handles.m5Record, 'String'), 'Start')
    set(handles.m5ClassI, 'Enable', 'off');
    set(handles.m5ClassII, 'Enable', 'off');
    set(handles.m5ClassIII, 'Enable', 'off');
    set(handles.m5ClassIV, 'Enable', 'off');
    set(handles.m5ClassV, 'Enable', 'off');
    set(handles.m5ClassVI, 'Enable', 'off');
else
    set(handles.m5ClassI, 'Enable', 'on');
    set(handles.m5ClassII, 'Enable', 'on');
    set(handles.m5ClassIII, 'Enable', 'on');
    set(handles.m5ClassIV, 'Enable', 'on');
    set(handles.m5ClassV, 'Enable', 'on');
    set(handles.m5ClassVI, 'Enable', 'on');
end

%Switch button from start to stop and vice versa
if strcmp(get(handles.m5Record, 'String'), 'Start')
    set(handles.m5Record, 'String', 'Stop', 'BackgroundColor', 'red');
elseif strcmp(get(handles.m5Record, 'String'), 'Stop')
    set(handles.m5Record, 'String', 'Start', 'BackgroundColor', [0.94 0.94 0.94]);
else
    errordlg('There was a problem with renaming the record button');
end

state.m5.times = [state.m5.times; clock];


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8



function m1Dose_Callback(hObject, eventdata, handles)
% hObject    handle to m1Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m1Dose as text
%        str2double(get(hObject,'String')) returns contents of m1Dose as a double
%set(handles.m1Vol,'String',num2str(((str2double(get(handles.m1Dose,'String')))*(str2double(get(handles.m1Weight,'String'))))));
global state
weight = str2double(get(handles.m1Weight, 'String'));
dose = str2double(get(handles.m1Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m1Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m1Dose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m1Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m2Dose_Callback(hObject, eventdata, handles)
% hObject    handle to m2Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m2Dose as text
%        str2double(get(hObject,'String')) returns contents of m2Dose as a double
%set(handles.m2Vol,'String',num2str(((str2double(get(handles.m2Dose,'String')))*(str2double(get(handles.m2Weight,'String'))))));
global state
weight = str2double(get(handles.m2Weight, 'String'));
dose = str2double(get(handles.m2Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m2Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m2Dose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m2Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m3Dose_Callback(hObject, eventdata, handles)
% hObject    handle to m3Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m3Dose as text
%        str2double(get(hObject,'String')) returns contents of m3Dose as a double
%set(handles.m3Vol,'String',num2str(((str2double(get(handles.m3Dose,'String')))*(str2double(get(handles.m3Weight,'String'))))));
global state
weight = str2double(get(handles.m3Weight, 'String'));
dose = str2double(get(handles.m3Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m3Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m3Dose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m3Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m4Dose_Callback(hObject, eventdata, handles)
% hObject    handle to m4Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m4Dose as text
%        str2double(get(hObject,'String')) returns contents of m4Dose as a double
%set(handles.m4Vol,'String',num2str(((str2double(get(handles.m4Dose,'String')))*(str2double(get(handles.m4Weight,'String'))))));
global state
weight = str2double(get(handles.m4Weight, 'String'));
dose = str2double(get(handles.m4Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m4Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m4Dose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m4Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function m5Dose_Callback(hObject, eventdata, handles)
% hObject    handle to m5Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of m5Dose as text
%        str2double(get(hObject,'String')) returns contents of m5Dose as a double
%set(handles.m5Vol,'String',num2str(((str2double(get(handles.m5Dose,'String')))*(str2double(get(handles.m5Weight,'String'))))));
global state
weight = str2double(get(handles.m5Weight, 'String'));
dose = str2double(get(handles.m5Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m5Vol, 'String', timeStr);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function m5Dose_CreateFcn(hObject, eventdata, handles)
% hObject    handle to m5Dose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global state

if ~exist('handles.savePath')
    handles.savePath = uigetdir;
end

    

if ispc
    filename = [handles.savePath '\' get(handles.expName, 'String')];
else
    filename = [handles.savePath '/' get(handles.expName, 'String')];
end
state.experimentName = get(handles.expName, 'String');

state.m1.Weight = str2double(get(handles.m1Weight, 'String'));
state.m1.Dose = str2double(get(handles.m1Dose, 'String'));
state.m1.Volume = str2double(get(handles.m1Vol, 'String'));

state.m2.Weight = str2double(get(handles.m2Weight, 'String'));
state.m2.Dose = str2double(get(handles.m2Dose, 'String'));
state.m2.Volume = str2double(get(handles.m2Vol, 'String'));

state.m3.Weight = str2double(get(handles.m3Weight, 'String'));
state.m3.Dose = str2double(get(handles.m3Dose, 'String'));
state.m3.Volume = str2double(get(handles.m3Vol, 'String'));

state.m4.Weight = str2double(get(handles.m4Weight, 'String'));
state.m4.Dose = str2double(get(handles.m4Dose, 'String'));
state.m4.Volume = str2double(get(handles.m4Vol, 'String'));

state.m5.Weight = str2double(get(handles.m5Weight, 'String'));
state.m5.Dose = str2double(get(handles.m5Dose, 'String'));
state.m5.Volume = str2double(get(handles.m5Vol, 'String'));

save(filename, 'state');



function expName_Callback(hObject, eventdata, handles)
% hObject    handle to expName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of expName as text
%        str2double(get(hObject,'String')) returns contents of expName as a double


% --- Executes during object creation, after setting all properties.
function expName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to expName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenVideo_Callback(hObject, eventdata, handles)
% hObject    handle to OpenVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SetSavePath_Callback(hObject, eventdata, handles)
% hObject    handle to SetSavePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.savePath = uigetdir;
guidata(hObject, handles);

% --------------------------------------------------------------------
function NewCohort_Callback(hObject, eventdata, handles)
% hObject    handle to NewCohort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ExitMenu_Callback(hObject, eventdata, handles)
% hObject    handle to ExitMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exit;


% --- Executes on button press in startVideo.
function startVideo_Callback(hObject, eventdata, handles)
% hObject    handle to startVideo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global state
switch get(handles.startVideo, 'String')
    case 'Start Video'
        %%stufff
        preview(state.cam);
        set(handles.startVideo, 'String', 'Stop Video');
        set(handles.startVideo, 'BackgroundColor', 'red');
        state.webcamTimer = timer('ExecutionMode', 'fixedSpacing');
        state.webcamTimer.Period = 1/state.acqRate;
        state.webcamTimer.TimerFcn = @videoStream;
        state.webcamTimer.StartFcn = @videoStart;
        state.webcamTimer.StopFcn = @videoStop;
        state.frameCounter = 0;
        
        if ~exist('handles.savePath')
            SetSavePath_Callback(hObject, eventdata, handles);
        end
        
        if ispc
            state.videoFileName = strcat(handles.savePath, '\', 'Video', '\', get(handles.expName, 'String'), '_video');
            state.videoFilePath = strcat(handles.savePath, '\', 'Video');
        else
            state.videoFileName = strcat(handles.savePath, '/', 'Video', '/', get(handles.expName, 'String'), '_video');
            state.videoFilePath = strcat(handles.savePath, '/', 'Video');
        end
        
        mkdir(state.videoFilePath);
        
        %state.saveTimer = timer('ExecutionMode', 'fixedSpacing');
        if ~isempty(state.cam)
            try
                start(state.webcamTimer);
            catch
                wardlg('Webcam Failed to Start');
            end
        end    

    case 'Stop Video'
        %stuff
        stop(state.webcamTimer);
        set(handles.startVideo, 'String', 'Start Video');
        set(handles.startVideo, 'BackgroundColor', [0.94 0.94 0.94]);
        closePreview(state.cam);
end



function videoStart(~,~)
global state
try
    state.video = im2frame(snapshot(state.cam));
    state.timestamps = clock;
    state.videoFileNum = 0;
catch ME
    sendErrorEmail(ME);
    throw(ME);
end
   


function videoStream(~,~)
global state
state.video = [state.video, im2frame(snapshot(state.cam))];
state.timestamps = [state.timestamps; clock];
state.frameCounter = state.frameCounter + 1;

if ~mod(state.frameCounter,state.acqRate*30)
    state.videoFileNum = state.videoFileNum + 1;
    state.videoFileSave = strcat(state.videoFileName, '_', num2str(state.videoFileNum), '.avi');
    state.videoTimeSave = strcat(state.videoFileName, '_', num2str(state.videoFileNum));
    %video = state.video;
    timestamps = state.timestamps;
    v = VideoWriter(state.videoFileSave);
    open(v);
    writeVideo(v, state.video);
    close(v);
    save(state.videoTimeSave, 'timestamps');
    state.video = im2frame(snapshot(state.cam));
    state.timestamps = clock;
end
    

function videoStop(~,~)
global state
state.videoFileNum = state.videoFileNum + 1;
state.videoFileSave = strcat(state.videoFileName, '_', num2str(state.videoFileNum), '.avi');
state.videoTimeSave = strcat(state.videoFileName, '_', num2str(state.videoFileNum));
%video = state.video;
timestamps = state.timestamps;
v = VideoWriter(state.videoFileSave);
open(v);
writeVideo(v, state.video);
close(v);
save(state.videoTimeSave, 'timestamps');
state.video = im2frame(snapshot(state.cam));
state.timestamps = clock;



% --------------------------------------------------------------------
function changeParam_Callback(hObject, eventdata, handles)
% hObject    handle to changeParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
changeParameters
global state

weight = str2double(get(handles.m1Weight, 'String'));
dose = str2double(get(handles.m1Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m1Vol, 'String', timeStr);

weight = str2double(get(handles.m2Weight, 'String'));
dose = str2double(get(handles.m2Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m2Vol, 'String', timeStr);

weight = str2double(get(handles.m3Weight, 'String'));
dose = str2double(get(handles.m3Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m3Vol, 'String', timeStr);

weight = str2double(get(handles.m4Weight, 'String'));
dose = str2double(get(handles.m4Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m4Vol, 'String', timeStr);

weight = str2double(get(handles.m5Weight, 'String'));
dose = str2double(get(handles.m5Dose, 'String'));
timeStr = getInfusionTime(dose, weight, state.KAconc, state.infusionRate)
set(handles.m5Vol, 'String', timeStr);

guidata(hObject, handles);
