function varargout = grav2d(varargin)
% GRAV2D M-file for grav2d.fig
%      GRAV2D, by itself, creates a new GRAV2D or raises the existing
%      singleton*.
%
%      H = GRAV2D returns the handle to a new GRAV2D or the handle to
%      the existing singleton*.
%
%      GRAV2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAV2D.M with the given input arguments.
%
%      GRAV2D('Property','Value',...) creates a new GRAV2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before grav2d_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to grav2d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help grav2d

% Last Modified by GUIDE v2.5 06-Nov-2011 21:49:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @grav2d_OpeningFcn, ...
                   'gui_OutputFcn',  @grav2d_OutputFcn, ...
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


% --- Executes just before grav2d is made visible.
function grav2d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to grav2d (see VARARGIN)

% Choose default command line output for grav2d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes grav2d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%*************************************************************************
%  Global variables for the program data

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global polycolor

MODEL_SETUP=0;      %  Initialize Model flag for setting up model.  When =1, model can be computed.
DATA_FROM_FILE=0;   %  No gravity anomaly data is available. =1 it is available
POLYGON_NUMBER=0;   %  Initialize the total number of polygons
CURRENT_POLYGON=0;  %  polygon being worked on

polycolor={'-k','-r','-g','-b','-c','-m' };     %  colors for the 6 possible polygons

% --- Outputs from this function are returned to the command line.
function varargout = grav2d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function xmin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin_edit as text
%        str2double(get(hObject,'String')) returns contents of xmin_edit as a double


% --- Executes during object creation, after setting all properties.
function xmin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax_edit as text
%        str2double(get(hObject,'String')) returns contents of xmax_edit as a double


% --- Executes during object creation, after setting all properties.
function xmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to zmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmax_edit as text
%        str2double(get(hObject,'String')) returns contents of zmax_edit as a double


% --- Executes during object creation, after setting all properties.
function zmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to delx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delx_edit as text
%        str2double(get(hObject,'String')) returns contents of delx_edit as a double


% --- Executes during object creation, after setting all properties.
function delx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deltaz_edit_Callback(hObject, eventdata, handles)
% hObject    handle to deltaz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltaz_edit as text
%        str2double(get(hObject,'String')) returns contents of deltaz_edit as a double


% --- Executes during object creation, after setting all properties.
function deltaz_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltaz_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plotdata_yes_radiobutton.
function plotdata_yes_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to plotdata_yes_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotdata_yes_radiobutton


% --- Executes on button press in compute_pushbutton.
function compute_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to compute_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  compute the 2D gravity anomaly for the polygon model setup

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly
global x0 ganom ngan
global xdat gravdat ndat
 
delx=str2num(get(handles.delx_edit,'String'));
delz=str2num(get(handles.deltaz_edit,'String'));
xmax=str2num(get(handles.xmax_edit,'String'));
xmin=str2num(get(handles.xmin_edit,'String'));
zmax=str2num(get(handles.zmax_edit,'String'));

% produce a grid of nodal points
nxg=(xmax-xmin)./delx +1;
xg=linspace(xmin,xmax,nxg);
nzg=(zmax./delz) + 1;
zg=linspace(0,zmax,nzg);

N=nxg.*nzg;

for kx=1:nxg;
    for kz=1:nzg;
        xs(kx,kz)=xg(kx);
        zs(kx,kz)=zg(kz);
    end;
end;

anom_delx=str2num(get(handles.anomaly_delx_edit,'String'));  % delx of anomaly computation
ngan=(xmax-xmin)./anom_delx + 1;
x0=linspace(xmin,xmax,ngan);
    
gtotal(POLYGON_NUMBER,1:ngan)=0.0;
ganom(1:ngan)=0.0;
%size(ganom)

%  big loop over each polygon
for kpoly=1:POLYGON_NUMBER;
    npx=np_poly(kpoly);
    drho=delrho(kpoly);
   
    px(1:npx)=poly_x(kpoly,1:npx);
    pz(1:npx)=poly_z(kpoly,1:npx);

    % determine if a nodal point is inside or outside the polygon
    IN=inpolygon(xs,zs,px,pz);

    % subset the nodal points in this polygon
    k=0;
    for kx=1:nxg;
        for kz=1:nzg
    
            if IN(kx,kz) == 1;
                k=k+1;
                xn(k)=xs(kx,kz);
                zn(k)=zs(kx,kz);
            end;
    
        end;
    end;
   
    mpoly=k;
    
    %  Now have x,z positions of the nodal points.  Compute gravity anomaly
    dmass=delx.*delz.*drho;     %mass increment for a small cylindrical element
    
    %ngan
    for kx=1:ngan;  % for each surface x for anomaly
        for mp=1:mpoly; %for each cylindrical element
            gtotal(kpoly,kx)=cylinder_anom(dmass,xn(mp),zn(mp),x0(kx)) + gtotal(kpoly,kx);
        end;
    end;
    
end;
%ngan
%  Sum anomaly over all polygons
for kx=1:ngan;
    for kpoly=1:POLYGON_NUMBER;
        ganom(kx)=gtotal(kpoly,kx)+ganom(kx);
    end;
end;
%size(gtotal)
%size(x0)
%size(ganom)
%  plot the anomaly on the anomaly_axes
pltvalue=get(handles.plotdata_yes_radiobutton,'Value');
if pltvalue == 0; plot(handles.anomaly_axes,x0(1:ngan),ganom(1:ngan),'-b'); end;
if pltvalue == 1; plot(handles.anomaly_axes,x0(1:ngan),ganom(1:ngan),'-b',xdat,gravdat,'o'); end;
xlabel(handles.anomaly_axes,'X position, km');
ylabel(handles.anomaly_axes,'Gravity Anomaly, mgal');
xlim(handles.anomaly_axes,[xmin xmax]);

return;


function polygonnum_edit_Callback(hObject, eventdata, handles)
% hObject    handle to polygonnum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of polygonnum_edit as text
%        str2double(get(hObject,'String')) returns contents of polygonnum_edit as a double


% --- Executes during object creation, after setting all properties.
function polygonnum_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polygonnum_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delrho_edit_Callback(hObject, eventdata, handles)
% hObject    handle to delrho_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delrho_edit as text
%        str2double(get(hObject,'String')) returns contents of delrho_edit as a double


% --- Executes during object creation, after setting all properties.
function delrho_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delrho_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in vertices_pushbutton.
function vertices_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to vertices_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly
global polycolor
%  Set up the model_axis figure 

axis(handles.model_axes, 'ij');
xmin=str2num(get(handles.xmin_edit,'String'));
xmax=str2num(get(handles.xmax_edit,'String'));
zmax=str2num(get(handles.zmax_edit,'String'));
axis(handles.model_axes,[xmin xmax 0 zmax]);
set(handles.model_axes,'XGrid','on','YGrid','on','ZGrid','on');

%  pick vertices for the current Polygon
[x,z]=getline(handles.model_axes,'closed');

%  load into polygon arrays
np=CURRENT_POLYGON;
nx=length(x);
poly_x(np,1:nx)=x(1:nx);
poly_z(np,1:nx)=z(1:nx);
delrho(np)=str2num(get(handles.delrho_edit,'String'));
np_poly(np)=nx;

%  plot all polygons on the plot
cla(handles.model_axes);
hold on;
np=POLYGON_NUMBER;
for k=1:np;
    kn=np_poly(k);
    plot(handles.model_axes,poly_x(k,1:kn),poly_z(k,1:kn),strcat(char(polycolor(k))));
    text(poly_x(k,1),poly_z(k,1),num2str(delrho(k)));
end;
hold off;

set(handles.pickvertics_edit,'String','Picks OK');

return;


function pickvertics_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pickvertics_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pickvertics_edit as text
%        str2double(get(hObject,'String')) returns contents of pickvertics_edit as a double



% --- Executes during object creation, after setting all properties.
function pickvertics_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pickvertics_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in newpolygon_pushbutton.
function newpolygon_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to newpolygon_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%   generate a new polygon

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON

POLYGON_NUMBER=POLYGON_NUMBER + 1;
set(handles.polygonnum_edit,'String',num2str(POLYGON_NUMBER));
set(handles.pickvertics_edit,'String','Picks Needed!');
CURRENT_POLYGON=POLYGON_NUMBER;

return;

% --- Executes on button press in editpolypicks_pushbutton.
function editpolypicks_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to editpolypicks_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  edit the polygon vertices picks by setting the polygon to whatever is in
%  the polygonnum_edit box and calling 

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly
global polycolor

set(handles.pickvertics_edit,'String','Picks Needed!');
CURRENT_POLYGON=str2num(get(handles.polygonnum_edit,'String'));

%  Set up the model_axis figure 

axis(handles.model_axes, 'ij');
xmin=str2num(get(handles.xmin_edit,'String'));
xmax=str2num(get(handles.xmax_edit,'String'));
zmax=str2num(get(handles.zmax_edit,'String'));
axis(handles.model_axes,[xmin xmax 0 zmax]);
set(handles.model_axes,'XGrid','on','YGrid','on','ZGrid','on');

%  pick vertices for the current Polygon
[x,z]=getline(handles.model_axes,'closed');

%  load into polygon arrays
np=CURRENT_POLYGON;
nx=length(x);
poly_x(np,1:nx)=x(1:nx);
poly_z(np,1:nx)=z(1:nx);
np_poly(np)=nx;

%  plot all polygons on the plot
cla(handles.model_axes);
hold on;
np=POLYGON_NUMBER;
for k=1:np;
    kn=np_poly(k);
    plot(handles.model_axes,poly_x(k,1:kn),poly_z(k,1:kn),strcat(char(polycolor(k))));
    text(poly_x(k,1),poly_z(k,1),num2str(delrho(k)));
end;
hold off;

set(handles.pickvertics_edit,'String','Picks OK');

return;


% --- Executes on button press in deletepolygon_pushbutton.
function deletepolygon_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to deletepolygon_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  delete a polygon from the model
global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly
global polycolor

CURRENT_POLYGON=str2num(get(handles.polygonnum_edit,'String'));

%  load into polygon array
np=CURRENT_POLYGON;
km=0;
kold=POLYGON_NUMBER;
for k=1:kold;
    if k == np; else;
        km=km+1;
        kn=np_poly(k);
        x(km,1:kn)=poly_x(k,1:kn);
        z(km,1:kn)=poly_z(k,1:kn);
        r(km)=delrho(k);
        np_1(km)=kn;
    end;
end;

poly_x=x;
poly_z=z;
delrho=r;
np_poly=np_1;

POLYGON_NUMBER=POLYGON_NUMBER-1;

%  plot all polygons on the plot
cla(handles.model_axes);
hold on;
np=POLYGON_NUMBER;
for k=1:np;
    kn=np_poly(k);
    plot(handles.model_axes,poly_x(k,1:kn),poly_z(k,1:kn),strcat(char(polycolor(k))));
    text(poly_x(k,1),poly_z(k,1),num2str(delrho(k)));
end;
hold off;

return;

% --------------------------------------------------------------------
function File_menu1_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Plot_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plot_separate_anomaly_fig_Callback(hObject, eventdata, handles)
% hObject    handle to plot_separate_anomaly_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly
global x0 ganom ngan
global xdat gravdat ndat

%  plot the anomaly on the anomaly_axes
figure;
pltvalue=get(handles.plotdata_yes_radiobutton,'Value');
if pltvalue == 0; plot(x0,ganom,'-b'); end;
if pltvalue == 1; plot(x0,ganom,'-b',xdat,gravdat,'o'); end;
xlabel('X position, km');
ylabel('Gravity Anomaly, mgal');
xlim([xmin xmax]);

return;

% --------------------------------------------------------------------
function plot_separate_model_fig_menu_Callback(hObject, eventdata, handles)
% hObject    handle to plot_separate_model_fig_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly
global x0 ganom ngan
global xdat gravdat ndat
global polycolor

%  plot all polygons on the plot
figure;
%  Set up the model_axis figure 
hold on;
np=POLYGON_NUMBER;
for k=1:np;
    kn=np_poly(k);
    plot(poly_x(k,1:kn),poly_z(k,1:kn),strcat(char(polycolor(k))));
    text(poly_x(k,1),poly_z(k,1),num2str(delrho(k)));
end;
axis ij;
xmin=str2num(get(handles.xmin_edit,'String'));
xmax=str2num(get(handles.xmax_edit,'String'));
zmax=str2num(get(handles.zmax_edit,'String'));
axis([xmin xmax 0 zmax]);
grid on;
hold off;

return;

% --------------------------------------------------------------------
function read_data_menu_Callback(hObject, eventdata, handles)
% hObject    handle to read_data_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  read x and gravity anomaly data from a file
global xdat gravdat ndat

% uigetfile dialog
[filename,dirname]=uigetfile('*.*');
resultfile=strcat(dirname,filename);
    
%   read  the file
fid=fopen(resultfile,'r');
[data,count]=fscanf(fid,'%g %g',[2 inf]);
data=data'
[ndat,ncol]=size(data)

xdat(1:ndat)=data(1:ndat,1)
gravdat(1:ndat)=data(1:ndat,2)

fclose(fid);

return;

% --------------------------------------------------------------------
function save_anomaly_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_anomaly_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  Save the computed gravity anomaly
%  Write this session's result to a file
global x0 ganom ngan

%  uiputfile dialog
[filename,dirname]=uiputfile('*.*');
resultfile=strcat(dirname,filename);
    
%   write results to the file
fid=fopen(resultfile,'w');

for kk=1:ngan;
    fprintf(fid,'%12.5f %12.5f\n',x0(kk),ganom(kk));
end;

fclose(fid);


% --------------------------------------------------------------------
function save_model_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_model_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  Save the polygon models to a file

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly

%  uiputfile dialog
[filename,dirname]=uiputfile('*.*');
resultfile=strcat(dirname,filename);
    
%   write results to the file
fid=fopen(resultfile,'w');

np=POLYGON_NUMBER;

for kk=1:np;
    fprintf(fid,' %u  %u  %g\n',kk,np_poly(kk),delrho(kk));
    for kn=1:np_poly(kk);
        fprintf(fid,'%12.5f %12.5f\n',poly_x(kk,kn),poly_z(kk,kn));
    end;
end;

fclose(fid);

% --- Executes on button press in editdelrho_pushbutton.
function editdelrho_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to editdelrho_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  change the value of delrho in Polygon Models Panel
global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global poly_x poly_z delrho np_poly
global polycolor

CURRENT_POLYGON=str2num(get(handles.polygonnum_edit,'String'));

%  load into polygon array
np=CURRENT_POLYGON;
delrho(np)=str2num(get(handles.delrho_edit,'String'));

%  plot all polygons on the plot
cla(handles.model_axes);
hold on;
np=POLYGON_NUMBER;
for k=1:np;
    kn=np_poly(k);
    plot(handles.model_axes,poly_x(k,1:kn),poly_z(k,1:kn),strcat(char(polycolor(k))));
    text(poly_x(k,1),poly_z(k,1),num2str(delrho(k)));
end;
hold off;

return;



function anomaly_delx_edit_Callback(hObject, eventdata, handles)
% hObject    handle to anomaly_delx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anomaly_delx_edit as text
%        str2double(get(hObject,'String')) returns contents of anomaly_delx_edit as a double


% --- Executes during object creation, after setting all properties.
function anomaly_delx_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anomaly_delx_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in init_plot_pushbutton.
function init_plot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to init_plot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  Initialize the model_axes with xmin, xmax, zmax
%  Zero out the polygons and initialize global variables

global MODEL_SETUP DATA_FROM_FILE POLYGON_NUMBER CURRENT_POLYGON
global polycolor

MODEL_SETUP=0;      %  Initialize Model flag for setting up model.  When =1, model can be computed.
DATA_FROM_FILE=0;   %  No gravity anomaly data is available. =1 it is available
POLYGON_NUMBER=0;   %  Initialize the total number of polygons
CURRENT_POLYGON=0;  %  polygon being worked on

%  Initialize model_axis figure 

axis(handles.model_axes, 'ij');
xmin=str2num(get(handles.xmin_edit,'String'));
xmax=str2num(get(handles.xmax_edit,'String'));
zmax=str2num(get(handles.zmax_edit,'String'));
axis(handles.model_axes,[xmin xmax 0 zmax]);
set(handles.model_axes,'XGrid','on','YGrid','on','ZGrid','on');
cla(handles.model_axes);

set(handles.polygonnum_edit,'String','0');
set(handles.pickvertics_edit,'String','Picks Needed!');
set(handles.delrho_edit,'String','0.0');

%  Initialize gravity anomaly figure
cla(handles.anomaly_axes);
axis(handles.anomaly_axes,[xmin xmax 0 1]);

return;


% --------------------------------------------------------------------
function info_menu_Callback(hObject, eventdata, handles)
% hObject    handle to info_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%  plot a figure with text info about this program

figure('Name','Info','Toolbar','none','MenuBar','none','Color','w');
axis off;
axis([0 5 0 5]);
text(0.,4.50,' XXXXXXXXXXXX   grav2d    XXXXXXXXXXX','FontSize',14);
text(0.25,4.25,'Set xmin, xmax, zmax for work area.  Push "Initialize"');
text(0.25,4.00,'Set up Polygon models by pushing "new" then "Pick Vertices" (6 polygons max)');
text(0.50,3.75,'Choose polygon vertices.  Double click to close polygon');
text(0.50,3.50,'The "Edit" button under "Pick Vertices" and "density contrast" change each.');
text(0.50,3.25,'Make sure you type in the Polygon number that you want to edit.');
text(0.50,3.00,'Change density contrast before hitting the "Edit" button');
text(0.50,2.75,'Press "New" button to add a polygon.');
text(0.50,2.50,'Press "Delete" button to delete the current polygon.');
text(0.25,2.25,'"Compute Anomaly" calculates and plots the gravity anomaly');
text(0.50,2.00,'"anomaly delta x is the sampling for the anomaly curve.');
text(0.50,1.75,'"grid delta z" and "grid delta x" is for the numerical integration.');
text(0.50,1.50,'"Plot Data from File" radiobutton should be pressed if data have been read.');
text(0.25,1.25,'"Read Data from "File" menu.');
text(0.25,1.00,'"File" menu can be used to save computed anomaly and polygon models to files.');
text(0.25,0.75,'"Plot" menu can be used to produce separate plots of the anomaly and models.');
text(0.25,0.30,' C.A. Langston, November 6, 2011','FontSize',10);

return;


% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
