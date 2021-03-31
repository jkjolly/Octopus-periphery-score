% Input path for the data
% datapath = uigetdir
% remove hidden files

datapath = 'C:\Users\jjolly.DESKTOP-RGKT43R\Documents\FMRIB\Analysis\octopus';
d = dir(datapath);
d = d(arrayfun(@(i) i.name(1), d) ~= '.');

% Label from file name

ID = {};
for i = 1:size(d,1)
    filename{i, 1} = d(i).name;
    ID{i, 1} = str2num(d(i).name(1:3));
end

% Read in the data files

for i = 1:length(filename)
  dataTable = readtable(fullfile(datapath,d(i).name));
  usefulData = dataTable(:,1:3);
  structure(i).x = table2array(usefulData(:,1));
  structure(i).y = table2array(usefulData(:,2));
  structure(i).seen = string(table2cell(usefulData(:,3)));
  structure(i).ID = ID(i)
  clear dataTable usefulData
end

% for i = 1:size(d,1);
%     T = readtable(filename(i).csv)
%     dataTable = readtable(dataCsv);usefulData = dataTable(:,1:3)structure.x = table2array(usefulData(:,1));
% structure.y = table2array(usefulData(:,2));
% structure.seen = string(table2cell(usefulData(:,3)));
% table2array converts the x and y columns to numerical arrays
% table2cell converts the seen column to a cell. string converts that cell array to a string array
% end

% Central 7 degrees analysis
% 4 out of 160 fall within the same area tested by MP, none within central
% 5 degs on both X and Y axes.

for i = 1:length(structure)
   structure(i).countcent = 0;
   for j = 1:length(structure(i).x)
       if abs(structure(i).x(j)) <= 7 && abs(structure(i).y(j)) <= 7
           if strcmp(structure(i).seen(j),'none')
               structure(i).countcent = structure(i).countcent + 1;
           else
               structure(i).countcent = structure(i).countcent;
           end
       end
   end
   structure(i).central = (((4 - structure(i).countcent)/4)*100)
end


% peripheral analysis so all the points outside of MP area
% n=156 points

for i = 1:length(structure)
   structure(i).countp = 0;
   for j = 1:length(structure(i).x)
       if abs(structure(i).x(j)) >= 7 && abs(structure(i).y(j)) >= 15
           if strcmp(structure(i).seen(j),'none')
               structure(i).countp = structure(i).countp + 1;
           else
               structure(i).countp = structure(i).countp;
           end
       end
   end
   structure(i).periphery = ((156 - structure(i).countp)/156)*100;
end
   