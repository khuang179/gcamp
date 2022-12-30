% script gCaMP activity analysis.m
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
tint=input(prompt)
Time=(raw_data(2:end,1).*tint)-tint

%trim the raw data.
Trimmed_data=raw_data(2:end, 2:end);
background=Trimmed_data(:,end);
init=Trimmed_data-background;
%Analysis
pkg load signal
  n=input("Choose column for analysis");
  r=medfilt1((init(1:end,n)), 200)
  a=(init(1:end,n))./r
  [val t]=findpeaks(a,"MinPeakHeight",1.5,"MinPeakDistance",4)
  t=t*tint

%Result plot for individual column
figure(1);
plot(Time,a,'b')
hold on;
scatter(t, val, 'm');
xlabel('Time (sec)');
ylabel('Amplitude(\Delta F/F_{0}');
ylim([0 5])
yticks(0:0.5:5)
saveas(figure(1),"gCaMP activity normalized.png");

figure(2);
plot(Time,init(1:end,n),'g');
hold on;
plot(Time,r);
xlabel('Time (sec)');
ylabel('fluorescnece intensity');
saveas(figure(2),"Nonnormalized activity with filtered curve.png");


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
