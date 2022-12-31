%script gCaMP activity analysis.m
%Author: KH.
%Varshney Lab, OMRF, OKC, OK.

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
pkg load signal
  n=str2num(inputdlg("Choose column for analysis"){1});
  r=medfilt1((init(1:end,n)), 200)
  a=(init(1:end,n))./r
  [val t]=findpeaks(a,"MinPeakHeight",1.5,"MinPeakDistance",4)
  t=t*tint
%Assign file name string and identify image files.
samplenum=num2str(n)
[directory,name,ext]=fileparts(filename);
ImageList=[(dir('*.png'));(dir('*.jpg'));(dir('*.bmp'));(dir('*.tif'))];
%Establish contains function, since Octave do not have natural contains function.
contains=@(Imagefiles, samplenum)~cellfun('isempty',strfind(Imagefiles, samplenum))
Imagefiles={ImageList.name}
%Search if the file directory have image files that partially match the sample number (search for png,jpg, bmp and tif files).
if  isempty(fieldnames(ImageList))
  result=0;
else contains(Imagefiles, samplenum)
result=contains(Imagefiles, samplenum)
end
%Result plot for individual column
if any(result) %if a result matrix from previous step is not a 0x1 empty struct, then question will pop up.
  button=questdlg('A plot for this sample of this specimen has already been created. Do you still want to proceed and make a new one to overwrite the old one?','Warning!','Yes','No','No');
  if strcmp(button,'Yes')
    figure(1);
    plot(Time,a,'b')
    hold on;
    scatter(t, val, 'm');
    xlabel('Time (sec)');
    ylabel('Amplitude(\Delta F/F_{0}');
    ylim([0 5])
    yticks(0:0.5:5)
    File_Name1=strcat(name,'_sample_', samplenum,'_Normalized activity')
      saveas(figure(1),File_Name1,'png')
      
    figure(2);
    plot(Time,init(1:end,n),'g');
    hold on;
    plot(Time,r);
    xlabel('Time (sec)');
    ylabel('fluorescnece intensity');
    File_Name2=strcat(name,'_sample_', samplenum,'_Nonnormalized activity with filter curve')
      saveas(figure(2),File_Name2,'png');
  elseif strcmp(button,'No'), end
else
  figure(1);
  plot(Time,a,'b')
  hold on;
  scatter(t, val, 'm');
  xlabel('Time (sec)');
  ylabel('Amplitude(\Delta F/F_{0}');
  ylim([0 5])
  yticks(0:0.5:5)
  File_Name1=strcat(name,'_sample_', samplenum,'_Normalized activity')
     saveas(figure(1),File_Name1,'png')
  
  figure(2);
  plot(Time,init(1:end,n),'g');
  hold on;
  plot(Time,r);
  xlabel('Time (sec)');
  ylabel('fluorescnece intensity');
  File_Name2=strcat(name,'_sample_', samplenum,'_Nonnormalized activity with filter curve')
    saveas(figure(2),File_Name2,'png');
end
if isfile('whole sample activity imagesc plot.png')
  button=questdlg('A matrix plot for all samples of this specimen has already been created. Do you still want to proceed and make a new one to overwrite the old one?','Warning!','Yes','No','No');
  if strcmp(button,'Yes')
    figure(3)
    activity=medfilt1(init, 200)
    activitysample=init(:,1:end-1)
    activity_normalized=activitysample./(activity(:,1:end-1))
    activity_normalized=activity_normalized'
    imagesc(activity_normalized)
    colorbar()
    saveas(figure(3),"whole sample activity imagesc plot.png")
  elseif strcmp(button,'No'),return,end
else
    figure(3)
    activity=medfilt1(init, 200)
    activitysample=init(:,1:end-1)
    activity_normalized=activitysample./(activity(:,1:end-1))
    activity_normalized=activity_normalized'
    imagesc(activity_normalized)
    colorbar()
    saveas(figure(3),"whole sample activity imagesc plot.png")
  end