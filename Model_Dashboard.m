+ function varargout = LapSimV3UI(varargin)
% LapSimV3UI MATLAB code for LapSimV3UI.fig
%      LapSimV3UI, by itself, creates a new LapSimV3UI or raises the existing
%      singleton*.
%
%      H = LapSimV3UI returns the handle to a new LapSimV3UI or the handle to
%      the existing singleton*.
%
%      LapSimV3UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LapSimV3UI.M with the given input arguments.
%
%      LapSimV3UI('Property','Value',...) creates a new LapSimV3UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LapSimV3UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LapSimV3UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LapSimV3UI

% Last Modified by GUIDE v2.5 27-May-2019 17:11:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LapSimV3UI_OpeningFcn, ...
                   'gui_OutputFcn',  @LapSimV3UI_OutputFcn, ...
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


% --- Executes just before LapSimV3UI is made visible.
function LapSimV3UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LapSimV3UI (see VARARGIN)

% Choose default command line output for LapSimV3UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LapSimV3UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LapSimV3UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function TireCf_inp_Callback(hObject, eventdata, handles)
% hObject    handle to TireCf_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TireCf_inp as text
%        str2double(get(hObject,'String')) returns contents of TireCf_inp as a double


% --- Executes during object creation, after setting all properties.
function TireCf_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TireCf_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function row_inp_Callback(hObject, eventdata, handles)
% hObject    handle to row_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of row_inp as text
%        str2double(get(hObject,'String')) returns contents of row_inp as a double


% --- Executes during object creation, after setting all properties.
function row_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CarMass_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CarMass_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CarMass_inp as text
%        str2double(get(hObject,'String')) returns contents of CarMass_inp as a double


% --- Executes during object creation, after setting all properties.
function CarMass_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CarMass_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nratio_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Nratio_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nratio_inp as text
%        str2double(get(hObject,'String')) returns contents of Nratio_inp as a double


% --- Executes during object creation, after setting all properties.
function Nratio_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nratio_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tmax_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Tmax_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tmax_inp as text
%        str2double(get(hObject,'String')) returns contents of Tmax_inp as a double


% --- Executes during object creation, after setting all properties.
function Tmax_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tmax_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pmax_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Pmax_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Pmax_inp as text
%        str2double(get(hObject,'String')) returns contents of Pmax_inp as a double


% --- Executes during object creation, after setting all properties.
function Pmax_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Pmax_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rtire_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Rtire_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rtire_inp as text
%        str2double(get(hObject,'String')) returns contents of Rtire_inp as a double


% --- Executes during object creation, after setting all properties.
function Rtire_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rtire_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CfdragBdy_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CfdragBdy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CfdragBdy_inp as text
%        str2double(get(hObject,'String')) returns contents of CfdragBdy_inp as a double


% --- Executes during object creation, after setting all properties.
function CfdragBdy_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CfdragBdy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Afbdy_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Afbdy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Afbdy_inp as text
%        str2double(get(hObject,'String')) returns contents of Afbdy_inp as a double


% --- Executes during object creation, after setting all properties.
function Afbdy_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Afbdy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CfdragFW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CfdragFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CfdragFW_inp as text
%        str2double(get(hObject,'String')) returns contents of CfdragFW_inp as a double


% --- Executes during object creation, after setting all properties.
function CfdragFW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CfdragFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AfFW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to AfFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AfFW_inp as text
%        str2double(get(hObject,'String')) returns contents of AfFW_inp as a double


% --- Executes during object creation, after setting all properties.
function AfFW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AfFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CfdownFW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CfdownFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CfdownFW_inp as text
%        str2double(get(hObject,'String')) returns contents of CfdownFW_inp as a double


% --- Executes during object creation, after setting all properties.
function CfdownFW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CfdownFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AfdownFW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to AfdownFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AfdownFW_inp as text
%        str2double(get(hObject,'String')) returns contents of AfdownFW_inp as a double


% --- Executes during object creation, after setting all properties.
function AfdownFW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AfdownFW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CfdragRW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CfdragRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CfdragRW_inp as text
%        str2double(get(hObject,'String')) returns contents of CfdragRW_inp as a double


% --- Executes during object creation, after setting all properties.
function CfdragRW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CfdragRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AfRW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to AfRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AfRW_inp as text
%        str2double(get(hObject,'String')) returns contents of AfRW_inp as a double


% --- Executes during object creation, after setting all properties.
function AfRW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AfRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CfdownRW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CfdownRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CfdownRW_inp as text
%        str2double(get(hObject,'String')) returns contents of CfdownRW_inp as a double


% --- Executes during object creation, after setting all properties.
function CfdownRW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CfdownRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AfdownRW_inp_Callback(hObject, eventdata, handles)
% hObject    handle to AfdownRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AfdownRW_inp as text
%        str2double(get(hObject,'String')) returns contents of AfdownRW_inp as a double


% --- Executes during object creation, after setting all properties.
function AfdownRW_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AfdownRW_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function CGx_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CGx_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CGx_inp as text
%        str2double(get(hObject,'String')) returns contents of CGx_inp as a double


% --- Executes during object creation, after setting all properties.
function CGx_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CGx_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CGy_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CGy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CGy_inp as text
%        str2double(get(hObject,'String')) returns contents of CGy_inp as a double


% --- Executes during object creation, after setting all properties.
function CGy_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CGy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function WheelBase_inp_Callback(hObject, eventdata, handles)
% hObject    handle to WheelBase_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WheelBase_inp as text
%        str2double(get(hObject,'String')) returns contents of WheelBase_inp as a double


% --- Executes during object creation, after setting all properties.
function WheelBase_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WheelBase_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CPx_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CPx_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CPx_inp as text
%        str2double(get(hObject,'String')) returns contents of CPx_inp as a double


% --- Executes during object creation, after setting all properties.
function CPx_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CPx_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CPy_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CPy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CPy_inp as text
%        str2double(get(hObject,'String')) returns contents of CPy_inp as a double


% --- Executes during object creation, after setting all properties.
function CPy_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CPy_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MomentInertia_inp_Callback(hObject, eventdata, handles)
% hObject    handle to MomentInertia_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MomentInertia_inp as text
%        str2double(get(hObject,'String')) returns contents of MomentInertia_inp as a double


% --- Executes during object creation, after setting all properties.
function MomentInertia_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MomentInertia_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end








% --- Executes on button press in RunSim.
function RunSim_Callback(hObject, eventdata, handles)
% hObject    handle to RunSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



 CP.TireCf = str2double(get(handles.TireCf_inp,'String'));
 CP.CarMass =  str2double(get(handles.CarMass_inp,'String'));
 CP.Rtire =  str2double(get(handles.Rtire_inp,'String'));
 CP.Pmax =  str2double(get(handles.Pmax_inp,'String'));
 CP.Tmax =  str2double(get(handles.Tmax_inp,'String'));
 CP.Nratio =  str2double(get(handles.Nratio_inp,'String'));
 CP.CG =  [str2double(get(handles.CGx_inp,'String')), str2double(get(handles.CGy_inp,'String'))] ;
 CP.WheelBase = str2double(get(handles.WheelBase_inp,'String'));
 CP.I = str2double(get(handles.MomentInertia_inp,'String'));
 CP.CarTrack = str2double(get(handles.CarTrack_inp,'String'));
 CP.ResCf = str2double(get(handles.ResCf_inp,'String'));
 CP.MechEff = str2double(get(handles.MechEff_inp,'String'));
 
 AP.CfdragBdy =  str2double(get(handles.CfdragBdy_inp,'String'));
 AP.Afbdy =  str2double(get(handles.Afbdy_inp,'String'));
 AP.CfdragFW =  str2double(get(handles.CfdragFW_inp,'String'));
 AP.CfdownFW =  str2double(get(handles.CfdownFW_inp,'String'));
 AP.AfFW =  str2double(get(handles.AfFW_inp,'String'));
 AP.CfdragRW =  str2double(get(handles.CfdragRW_inp,'String'));
 AP.CfdownRW =  str2double(get(handles.CfdownRW_inp,'String'));
 AP.AfRW =  str2double(get(handles.AfRW_inp,'String'));
 AP.CP =  [str2double(get(handles.CPx_inp,'String')), str2double(get(handles.CPy_inp,'String'))];
 
 TP.Rcont1 = str2double(get(handles.Rcont1_inp,'String'));
 TP.Rcont2 = str2double(get(handles.Rcont2_inp,'String'));
 TP.Rcond1 = str2double(get(handles.Rcond1_inp,'String'));
 TP.CellHeatCap = str2double(get(handles.CellHeatCap_inp,'String'));
 TP.Cellrho = str2double(get(handles.Cellrho_inp,'String'));
 TP.BaseHeatCap = str2double(get(handles.BaseHeatCap_inp,'String'));
 TP.Baserho = str2double(get(handles.Baserho_inp,'String'));
 TP.BaseArea = str2double(get(handles.BaseArea_inp,'String'));
 TP.BaseVolume = str2double(get(handles.BaseVolume_inp,'String'));
 TP.Tamb = str2double(get(handles.Tamb_inp,'String'));
 
 
 %PhysicsModel(TireCf,row, CarMass, Rtire, Pmax, Tmax, Nratio, CfdragBdy,Afbdy,CfdragFW, AfdragFW,CfdownFW,AfdownFW,CfdragRW,AfdragRW,CfdownRW,AfdownRW)
 [ThermalData, SectorData] = PhysicsModel_V3_1wheel(CP, AP);
 
 figure;
 xlabel('Lap Segment');
 ylabel('Power (kW)');
 yyaxis right;
 
plot(1:length(ThermalData),ThermalData(:,2));
 yyaxis left;
 %ylabel('Speed (m/s)');
 plot(1:length(ThermalData),SectorData(:,3));
 
%figure;
%plot(1:length(SectorData),SectorData(:,3));


 Lap_T3Cell(1) = TP.Tamb;
 Lap_Tbase(1) = TP.Tamb;
 All_T3Cell(1) = TP.Tamb;
 All_Tbase(1) = TP.Tamb;
 j=1;
 k=1;
 
 for i = 1:1
     
    [Lap_T3Cell(i+1,1), Lap_Tbase(i+1,1),T3cell, Tbase] = ThermalCalc(ThermalData, TP, Lap_T3Cell(i,1), Lap_Tbase(i,1), CP, SectorData);   
    
    All_T3Cell =[ All_T3Cell, T3cell];
    All_Tbase = [ All_Tbase, Tbase];
   
    
 end
 save("25C Convective - Aluminum Fins",'Lap_T3Cell', 'Lap_Tbase');
 %t = linspace(1,length(All_T3Cell),length(All_T3Cell));
 t = linspace(1,length(Lap_T3Cell),length(Lap_T3Cell));
 figure,plot(t, Lap_T3Cell(:,1),'g');
 hold on;
 plot(t,Lap_Tbase(:,1), 'r');
  title('Endurance Thermal Model','fontsize',20)
    xlabel('Lap','fontsize',20) % x-axis label
    ylabel('Temp (C)','fontsize',20) % y-axis label
 
 



function CarTrack_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CarTrack_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CarTrack_inp as text
%        str2double(get(hObject,'String')) returns contents of CarTrack_inp as a double


% --- Executes during object creation, after setting all properties.
function CarTrack_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CarTrack_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ResCf_inp_Callback(hObject, eventdata, handles)
% hObject    handle to ResCf_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ResCf_inp as text
%        str2double(get(hObject,'String')) returns contents of ResCf_inp as a double


% --- Executes during object creation, after setting all properties.
function ResCf_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResCf_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MechEff_inp_Callback(hObject, eventdata, handles)
% hObject    handle to MechEff_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MechEff_inp as text
%        str2double(get(hObject,'String')) returns contents of MechEff_inp as a double


% --- Executes during object creation, after setting all properties.
function MechEff_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MechEff_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rcont1_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Rcont1_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rcont1_inp as text
%        str2double(get(hObject,'String')) returns contents of Rcont1_inp as a double


% --- Executes during object creation, after setting all properties.
function Rcont1_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rcont1_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rcont2_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Rcont2_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rcont2_inp as text
%        str2double(get(hObject,'String')) returns contents of Rcont2_inp as a double


% --- Executes during object creation, after setting all properties.
function Rcont2_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rcont2_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rcond1_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Rcond1_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rcond1_inp as text
%        str2double(get(hObject,'String')) returns contents of Rcond1_inp as a double


% --- Executes during object creation, after setting all properties.
function Rcond1_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rcond1_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CellHeatCap_inp_Callback(hObject, eventdata, handles)
% hObject    handle to CellHeatCap_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CellHeatCap_inp as text
%        str2double(get(hObject,'String')) returns contents of CellHeatCap_inp as a double


% --- Executes during object creation, after setting all properties.
function CellHeatCap_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CellHeatCap_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Cellrho_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Cellrho_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cellrho_inp as text
%        str2double(get(hObject,'String')) returns contents of Cellrho_inp as a double


% --- Executes during object creation, after setting all properties.
function Cellrho_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cellrho_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BaseHeatCap_inp_Callback(hObject, eventdata, handles)
% hObject    handle to BaseHeatCap_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BaseHeatCap_inp as text
%        str2double(get(hObject,'String')) returns contents of BaseHeatCap_inp as a double


% --- Executes during object creation, after setting all properties.
function BaseHeatCap_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BaseHeatCap_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Baserho_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Baserho_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Baserho_inp as text
%        str2double(get(hObject,'String')) returns contents of Baserho_inp as a double


% --- Executes during object creation, after setting all properties.
function Baserho_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Baserho_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BaseArea_inp_Callback(hObject, eventdata, handles)
% hObject    handle to BaseArea_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BaseArea_inp as text
%        str2double(get(hObject,'String')) returns contents of BaseArea_inp as a double


% --- Executes during object creation, after setting all properties.
function BaseArea_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BaseArea_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BaseVolume_inp_Callback(hObject, eventdata, handles)
% hObject    handle to BaseVolume_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BaseVolume_inp as text
%        str2double(get(hObject,'String')) returns contents of BaseVolume_inp as a double


% --- Executes during object creation, after setting all properties.
function BaseVolume_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BaseVolume_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tamb_inp_Callback(hObject, eventdata, handles)
% hObject    handle to Tamb_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tamb_inp as text
%        str2double(get(hObject,'String')) returns contents of Tamb_inp as a double


% --- Executes during object creation, after setting all properties.
function Tamb_inp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tamb_inp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
