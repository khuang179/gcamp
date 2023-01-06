%script mass trial.m
%Author: KH.
%Varshney Lab, OMRF, OKC, OK.
clear all %Make sure not other scripts are running before execution of this script.
%Load CSV data file of the gCaMP activity as measured in ImageJ.
%Make sure each CSV file represents a sample and has its own folder for analysis.
%define files to open.
working_directory=pwd
files=dir('*.csv')
filename=files(1).name;
disp(filename);
raw_data=csvread(filename);
%Ask for time interval
prompt="Please enter time interval of the image sequence in sec";
tint=str2num(inputdlg(prompt){1})
Time=(raw_data(2:end,1).*tint)-tint
%trim the raw data.
Trimmed_data=raw_data(2:end, 2:end);
background=Trimmed_data(:,end);
init=Trimmed_data-background;
%Analysis
[directory,name,ext]=fileparts(filename);
pkg load signal
[nrow ncol]=size(init);
for c=1:(ncol-1)
  r=medfilt1((init(1:end,c)), 200)
  a=(init(1:end,c))./r
  [val t]=findpeaks(a,"MinPeakHeight",1.5,"MinPeakDistance",4)
  t=t*tint
  figure(c)
  subplot(2,1,1);
  plot(Time,a,'b')
  hold on;
  scatter(t, val, 'm');
  xlabel('Time (sec)');
  ylabel('Amplitude(\Delta F/F_{0}');
  subplot(2,1,2);
  plot(Time,init(1:end,c),'g');
    hold on;
    plot(Time,r);
    xlabel('Time (sec)');
    ylabel('fluorescnece intensity');
 File_Namec=strcat(name,'_sample_',num2str(c),'_firing activity')
 saveas(figure(c),File_Namec,'png')
end
close all
 figure(1)
 activity=medfilt1(init, 200)
    activitysample=init(:,1:end-1)
    activity_normalized=activitysample./(activity(:,1:end-1))
    activity_normalized=activity_normalized'
    imagesc(activity_normalized)
    colorbar()
    saveas(figure(1),"whole sample activity imagesc plot.png")
    
 Workspacename=strcat(name,' variables.mat');
  save(Workspacename);
clear all
close all