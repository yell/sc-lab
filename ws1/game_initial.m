function varargout = game(varargin)
% GAME MATLAB code for game.fig

% Edit the above text to modify the response to help game

% Last Modified by GUIDE v2.5 25-Oct-2016 15:29:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @game_OpeningFcn, ...
    'gui_OutputFcn',  @game_OutputFcn, ...
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


%
%%% --- SECTION WHERE YOU CAN EDIT (MODIFY/ADD FUNCTIONS AS NEEDED) --- %%%
%


% --- Executes on button press in pushbuttonsave.
function pushbuttonsave_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% save last transition matrix and anything else you want saved before closing
global transm results numrounds policy gametype
filename = strcat('data_',num2str(gametype),'_',num2str(policy),'_',num2str(numrounds));
save(filename,'transm','results')


function testChoice(userchoice,handles)
global history nowins nolosses nodraws results
switch userchoice
    case 1 % rock
        if history(end,1) == 3
            nowins = nowins + 1;
            result = 'You win, computer chose scissors!';
        elseif history(end,1) == 1
            nodraws = nodraws + 1;
            result = 'Draw, computer chose rock as well!';
        else 
            nolosses = nolosses + 1;
            result = 'You lose, computer chose paper!';
        end
    case 2 % paper
        if history(end,1) == 1
            nowins = nowins + 1;
            result = 'You win, computer chose rock!';
        elseif history(end,1) == 2
            nodraws = nodraws + 1;
            result = 'Draw, computer chose paper as well!';
        else
            nolosses = nolosses + 1;
            result = 'You lose, computer chose scissors!';
        end
    case 3 % scissors
        if history(end,1) == 2
            nowins = nowins + 1;
            result = 'You win, computer chose paper!';
        elseif history(end,1) == 3
            nodraws = nodraws + 1;
            result = 'Draw, computer chose scissors as well!';
        else
            nolosses = nolosses + 1;
            result = 'You lose, computer chose rock!';
        end
end
handles.textlosses.String = strcat('Losses: ',num2str(nolosses));
handles.textwins.String = strcat('Wins: ',num2str(nowins));
handles.textdraws.String = strcat('Draws: ',num2str(nodraws));
norounds = size(history,1);
handles.textround.String = strcat('Round: ',num2str(norounds));
handles.textresult.String = result;
results = [results,nowins-nolosses];
history(end,2) = userchoice;

if norounds == 1
    line([1,1],[0,results],'Parent',handles.axes,'LineWidth',3)
    next = mchoice(norounds,0,0);
else
    plot(handles.axes,1:norounds,results,'LineWidth',3)
    next = mchoice(norounds,history(end-1,2),history(end,2));
end
history = [history;[next,0]];


%
%%% --- DO NOT EDIT THE CODE BELOW ---  %%%
%


% --- Executes just before game is made visible.
function game_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to game (see VARARGIN)

global history nowins nolosses nodraws results policy numrounds
% Choose default command line output for game
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

policy = 1; numrounds = 1;
history = [randi(3),0];
nowins = 0; nolosses = 0; nodraws = 0; results = [];
handles.textlosses.String = strcat('Losses: ',num2str(nolosses));
handles.textwins.String = strcat('Wins: ',num2str(nowins));
handles.textdraws.String = strcat('Draws: ',num2str(nodraws));
handles.textround.String = strcat('Round: ',num2str(size(history,1)-1));

handles.axes.Title.String = '#Wins-#Losses vs. #Rounds'; 
handles.axes.FontSize = 12;

% UIWAIT makes game wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = game_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbuttonrock.
function pushbuttonrock_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonrock (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testChoice(1,handles);

% --- Executes on button press in pushbuttonpaper.
function pushbuttonpaper_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonpaper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testChoice(2,handles);

% --- Executes on button press in pushbuttonscissors.
function pushbuttonscissors_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonscissors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
testChoice(3,handles);


% --- Executes on button press in pushbuttonstart.
function pushbuttonstart_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global policy numrounds gametype param_a param_b

% Interpret GUI information
gametype = str2double(handles.gametypegroup.SelectedObject.Tag(end));
policy = str2double(handles.policiesgroup.SelectedObject.Tag(end));
numrounds = 0; % as a default

param_a = 0; param_b = 0; % some default values

if policy == 1 % check the policy parameters
    param_a = str2double(handles.editparam1.String);
    param_b = str2double(handles.editparam2.String);
    if param_a < 0 || param_a > 1 || param_b < 0 || ...
            param_b > 1 || param_a > param_b
        handles.texterror.String = 'ERROR: Invalid transition matrix! Retry';
        return;
    end
end

switch gametype
    case 1
        % disable/enabele GUI elements
        handles.gametype1.Enable = 'Off';
        handles.gametype2.Enable = 'Off';
        handles.noroundsedit.Enable = 'Off';
        handles.policy1.Enable = 'Off';
        handles.policy2.Enable = 'Off';
        handles.policy3.Enable = 'Off';
        handles.checkboxtransm.Enable = 'Off';
        handles.fixedtransm11.Enable = 'Off';
        handles.fixedtransm12.Enable = 'Off';
        handles.fixedtransm13.Enable = 'Off';
        handles.fixedtransm21.Enable = 'Off';
        handles.fixedtransm22.Enable = 'Off';
        handles.fixedtransm23.Enable = 'Off';
        handles.fixedtransm31.Enable = 'Off';
        handles.fixedtransm32.Enable = 'Off';
        handles.fixedtransm33.Enable = 'Off';
        set(hObject,'Visible','Off');
        
        handles.editparam1.Enable = 'Off';
        handles.editparam2.Enable = 'Off';

        handles.textresult.Visible = 'On';
        handles.texterror.Visible = 'Off';
        
        % Enable player buttons
        handles.pushbuttonrock.Visible = 'On';
        handles.pushbuttonpaper.Visible = 'On';
        handles.pushbuttonscissors.Visible = 'On';
        
        % Enable exit and save buttons
        handles.pushbuttonexit.Visible = 'On';
        handles.pushbuttonsave.Visible = 'On';
    case 2
        htransm = [];
        if handles.checkboxtransm.Value == 1 % check if transition matrix is given by user directly
            % get htransm and check it
            htransm = ...
               [double(sym(handles.fixedtransm11.String)), ...
                double(sym(handles.fixedtransm12.String)), ...
                double(sym(handles.fixedtransm13.String)); ...
                double(sym(handles.fixedtransm21.String)), ...
                double(sym(handles.fixedtransm22.String)), ...
                double(sym(handles.fixedtransm23.String)); ...
                double(sym(handles.fixedtransm31.String)), ...
                double(sym(handles.fixedtransm32.String)), ...
                double(sym(handles.fixedtransm33.String))];
            if check_transm(htransm) == 0
                handles.texterror.String = 'ERROR: Invalid transition matrix! Retry';
                return;
            end
        end        
        % get number of simulated rounds
        numrounds = max(1,round(str2double(handles.noroundsedit.String)));
        
        % disable/enabele GUI elements
        handles.gametype1.Enable = 'Off';
        handles.gametype2.Enable = 'Off';
        handles.noroundsedit.Enable = 'Off';
        handles.policy1.Enable = 'Off';
        handles.policy2.Enable = 'Off';
        handles.policy3.Enable = 'Off';
        handles.checkboxtransm.Enable = 'Off';
        handles.fixedtransm11.Enable = 'Off';
        handles.fixedtransm12.Enable = 'Off';
        handles.fixedtransm13.Enable = 'Off';
        handles.fixedtransm21.Enable = 'Off';
        handles.fixedtransm22.Enable = 'Off';
        handles.fixedtransm23.Enable = 'Off';
        handles.fixedtransm31.Enable = 'Off';
        handles.fixedtransm32.Enable = 'Off';
        handles.fixedtransm33.Enable = 'Off';
        set(hObject,'Visible','Off');
        
        handles.editparam1.Enable = 'Off';
        handles.editparam2.Enable = 'Off';

        handles.textresult.Visible = 'On';
        handles.texterror.Visible = 'Off';
        
        % run simulation
        run_sim(handles, htransm);
        
        % show exit and save buttons when done
        handles.pushbuttonexit.Visible = 'On';
        handles.pushbuttonsave.Visible = 'On';
    otherwise
        disp('How did you manage to get here? You shouldn",t be seeing this...');
end


%%% Main function for the simulation gametype
function run_sim(handles, htransm)
global numrounds
if isempty(htransm)
    userchoice = randi(3); % first move is random; no need for a strategy
    testChoice(userchoice,handles);
    for i=2:numrounds
        userchoice = gen_human_move(i); % explicit strategy instead of a human move
        testChoice(userchoice,handles);
    end
else
    userchoice = randi(3); % first move is random; no need for a strategy
    testChoice(userchoice,handles);
    for i=2:numrounds
        userchoice = get_move_from_transm(htransm); % get human move from transition matrix
        testChoice(userchoice,handles);
    end
end


%%% Get the move of the player from a given transition matrix
function userchoice = get_move_from_transm(htransm)
% htransm = transition matrix for human moves
global history
i = history(end-1,2); % get last human move (we start with move two, so it exists!)
r = rand;
userchoice = sum(r>=cumsum([0,htransm(i,:)]));


%%% Checks if the given transition matrix is valid
function res = check_transm(htransm)
if sum(htransm(1,:)) == 1 && sum(htransm(2,:)) == 1 && sum(htransm(3,:)) == 1
    res = 1; return;
end
res = 0;


% --- Executes on button press in pushbuttonexit.
function pushbuttonexit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure1);


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in checkboxtransm.
function checkboxtransm_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxtransm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxtransm
val = get(hObject,'Value');
if val == 1
    handles.transmgroup.Visible = 'On';
else
    handles.transmgroup.Visible = 'Off';
end


% --- Executes during object creation, after setting all properties.
function fixedtransm11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function fixedtransm33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fixedtransm33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function noroundsedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noroundsedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gametype1.
function gametype1_Callback(hObject, eventdata, handles)
% hObject    handle to gametype1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gametype1
% User v. PC game
handles.noroundsgroup.Visible = 'Off';
handles.checkboxtransm.Visible = 'Off';
handles.transmgroup.Visible = 'Off';


% --- Executes on button press in gametype2.
function gametype2_Callback(hObject, eventdata, handles)
% hObject    handle to gametype2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gametype2
handles.noroundsgroup.Visible = 'On';
handles.checkboxtransm.Visible = 'On';
if handles.checkboxtransm.Value == 1
    handles.transmgroup.Visible = 'On';
else
    handles.transmgroup.Visible = 'Off';
end


% --- Executes during object creation, after setting all properties.
function editparam1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editparam1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function editparam2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editparam2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in policiesgroup.
function policiesgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in policiesgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = handles.policiesgroup.SelectedObject.Tag(end);
if val == '1'
    handles.panelparams.Visible = 'On';
else
    handles.panelparams.Visible = 'Off';
end


% --- Executes on key press with focus on pushbuttonrock and none of its controls.
function pushbuttonrock_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonrock (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonpaper and none of its controls.
function pushbuttonpaper_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonpaper (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonscissors and none of its controls.
function pushbuttonscissors_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonscissors (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonsave and none of its controls.
function pushbuttonsave_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonsave (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on pushbuttonexit and none of its controls.
function pushbuttonexit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonexit (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Character
    case '1'
        pushbuttonrock_Callback(hObject, eventdata, handles)
    case '2'
        pushbuttonpaper_Callback(hObject, eventdata, handles)
    case '3'
        pushbuttonscissors_Callback(hObject, eventdata, handles)
end


