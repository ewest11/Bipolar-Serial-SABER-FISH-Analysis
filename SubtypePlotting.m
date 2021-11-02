%% Load data matrix
Retina_1_Table=readtable('Retina1.csv')

% Matrix includes all cells classified as bipolar subtypes from Retina 1.
% This matrix includes cell locations, identities, and gene expression
% profiles quantified as SABER-FISH puncta-per-cell.

% RetinaNumber = Index of retina (1-3)

% SectionNumber = Index of section (1-3). Three serial sections were
%   collected from each retina, each 35um thick.

% ImageNumber = Each retina was imaged as a series of non-overlapping image regions. 
%   Each image was 332.8um x 332.8um and 2048 pixels x 2048 pixels. These images were 
%   analyzed separately and stitched together at the end. Some image numbers are skipped for 
%   some sections, indicating that the serial images failed to align perfectly, resulting in unusable
%   data. Retina 1, Section 1 did not face this issue and thus is a
%   completely continuous reconstruction. A continuous reconstruction was made for 
%   Retinas 1 and 2 by combining the data across sections, based on arclength along the DV axis.

% WatershedIndex = Object index within watershed file.

% Centroid_1 = X-coordinate of cell body centroid in the original image
% (unit is pixels)

% Centroid_2 = Y-coordinate of cell body centroid in the original image
% (unit is pixels)

% Centroid_3 = Z-coordinate of cell body centroid in the original image
% (unit is pixels)

% ArcLength = Location along the dorsoventral axis, measured on a scale of
% [0 1], where 0 is Dorsal and 1 is Ventral.

% OPL_Distance = Projection distance between centroid location and the
% outer plexiform layer (OPL)

% Remapped_X = X-coordinate of cell centroid after computational image
% stitching to recover full retinal section. See below for example.

% Remapped_Y = Y-coordinate of cell centroid after computational image
% stitching to recover full retinal section. See below for example.

% Subtype = Subtype identity [1-15], mapping, in order, to: types={' 1a',' 1b',' 2',' 3a',' 3b',' 4',' 5a',' 5b',' 5c',' 5d',' 6',' 7',' 8',' 9',' RBP'};

% BirthdateIndex_1 = [0,1]: 1 = Cell was BrdU-/EdU-; 0 = False (i.e. Cell
% was born before P3)

% BirthdateIndex_2 = [0,1]: 1 = Cell was BrdU+/EdU-; 0 = False (i.e. Cell
% was born on P3-P4)

% BirthdateIndex_3 = [0,1]: 1 = Cell was BrdU+/EdU+; 0 = False (i.e. Cell
% was born after P3, but was in S-phase at the time of BrdU injection on P3)

% BirthdateIndex_4 = [0,1]: 1 = Cell was BrdU-/EdU+; 0 = False (i.e. Cell
% was born after P3, and was not in S-phase at the time of BrdU injection on P3)

% The last 16 columns represent SABER-FISH puncta-per-cell counts for each
% marker gene (labelled by column names). 
%% Visualize cell centroids for all subtypes in Retina 1, Section 1, Image 9
tf=Retina_1_Table(Retina_1_Table.SectionNumber==1 & Retina_1_Table.ImageNumber==9,:)

% Plot cell centroids within the original image axes, with each subtype colored
figure;
scatter(tf.Centroid_1,tf.Centroid_2,50,tf.Subtype,'filled')

% Label each cell centroid according to subtype identity
colormap(myColorMap(2:end,:)) % colormap used in the paper
types={' 1a',' 1b',' 2',' 3a',' 3b',' 4',' 5a',' 5b',' 5c',' 5d',' 6',' 7',' 8',' 9',' RBP'};
co=colorbar;
co.Ticks=[1:1:16]
co.TickLabels=types

%Images were 2048 pixels x 2048 pixels, so resize X and Y axes accordingly
xlim([0 2048]) 
ylim([0 2048])
title('Bipolar Subtypes, Retina 1, Section 1, Image 9')
xlabel('X-Axis Pixels')
ylabel('Y-Axis Pixels')

%% Plot full section with subtypes (from Figure 2)

tf=Retina_1_Table(Retina_1_Table.SectionNumber==1,:)

% Plot cell centroids after image stitching
figure;
scatter(tf.Remapped_X,tf.Remapped_Y,10,tf.Subtype,'filled')

% Label each cell centroid according to subtype identity
colormap(myColorMap(2:end,:)) % colormap used in the paper
types={' 1a',' 1b',' 2',' 3a',' 3b',' 4',' 5a',' 5b',' 5c',' 5d',' 6',' 7',' 8',' 9',' RBP'};
co=colorbar;
co.Ticks=[1:1:16]

co.TickLabels=types

title('Bipolar Subtypes, Retina 1, Section 1')

%% Plot tSNE of bipolar cells (from Supplementary Figure 2)
figure;
% 3-D scatter plot of tSNE representation
scatter3(Retina1Table.tSNE1,Retina1Table.tSNE2,Retina1Table.tSNE3,35,Retina1Table.Subtype,'filled', 'MarkerFaceAlpha',.80);
hold on
title('Dimensional Reduction of Bipolar Cells','FontSize',20)
grid off

% set specific viewpoint
view(gca,[37.8000002239186 -5.45167882639437]);

% white background
  set(gcf,'color','w');
  
% Font size
  set(gca,'FontSize',15)
  
% label axes
xlabel('tSNE1','FontSize',20)
ylabel('tSNE2','FontSize',20)
zlabel('tSNE3','FontSize',20)
zticks([-100,-50,0,50,100])

% Color cells according to their subtype identity
colormap(myColorMap(2:end,:)) % colormap used in the paper
types={' 1a',' 1b',' 2',' 3a',' 3b',' 4',' 5a',' 5b',' 5c',' 5d',' 6',' 7',' 8',' 9',' RBP'};
% Display colorbar with subtype labels
co=colorbar;
co.Ticks=[1:1:16]
co.TickLabels=types







