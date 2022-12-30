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
ans=input(prompt)
Time=(raw_data(2:end,1).*ans)-ans

%trim the raw data.
Trimmed_data=raw_data(2:end, 2:end);
background=Trimmed_data(:,end);
init=Trimmed_data-background;
%Analysis
pkg load signal;

prompt2="Choose column for analysis";
n=input(prompt2);
r=medfilt1((init(1:end,n)), 200)
a=(init(1:end,n))./r
base=abs(a-1)
[val t]=findpeaks(base,"MinPeakHeight",1)

%Result plot for individual column
figure(1);
plot(Time,base,'m')
hold on;
scatter(t, val);
xlabel('Time (sec)');
ylabel('Amplitude(\Delta F/F_{0}');


figure(2);
plot(init(1:end,n),'g')
hold on;
plot(r);
xlabel('Time (sec)');
ylabel('fluorescnece intensity');












%[r,c]=size(init)
