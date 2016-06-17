%% Author: Bipul Mohanto
% email: bipul.mohanto@yahoo.com
%02/03/2014
%camera calibration

clear all;
close all;
clc

%% part I
tp=0.2; % tp is the time duration between the images shown
[I]=ChargementSeqIm('Material\PPCalibratedPatternImage','.bmp',5,0);% 5 is the total number of images (PP are already processed)
figure(1);
for c=1:5
	imshow(I(:,:,c),[]);colorbar;title(sprintf('Image number n %d',c));pause(tp);
end

%% part II.1 thresholding and noise reduction
% II.1. Applied threshold (0.8) in order to get a BW image
figure(2);
for c=1:5
    bw(:,:,c)=im2bw(uint8(I(:,:,c)),0.8); %thresholding (0.8)
    imshow(bw(:,:,c),[]);colorbar;title(sprintf('Image number n %d',c));pause(tp);
end
% Applied morphological operations in order to remove the noise in the image
se = strel('disk',4);
figure(3);
PTIS=bw;
for c=1:5
    PTIS(:,:,c)=imclose(PTIS(:,:,c),se);
    imshow(PTIS(:,:,c),[]);colorbar;title(sprintf('Image number n %d',c));pause(tp);
end

%% II.2. Obtain the labels of the image objects
figure(3);
imgLabel=PTIS;
for c=1:5
	L(:,:,c)=bwlabel(PTIS(:,:,c));
    imshow(L(:,:,c),[]);colormap(hsv);colorbar;title(sprintf('Image number n %d',c));pause(tp);
end

%% II.3. Detect the centroids of each object and locate it. Finally display
figure(4);
for c=1:5
    objCnt=regionprops(L(:,:,c),'Centroid');
    centres(:,:,c) = cat(1, objCnt.Centroid);
    imshow(PTIS(:,:,c),[]);colorbar;
    hold on; plot(centres(:,1,c),centres(:,2,c),'+');
    plot(centres(:,1,c),centres(:,2,c),'m');title('Images of patterns + detected centroids');pause(tp);
end

%% Task - III :	Arrange a matrix of 3D coordinates and 
% a matrix of 2D coordinates of the projected points in the image.

%% III.2. Build Matrix uivi
%figure(5)

uivi=[]
for c = 1:5
        uivi = [uivi;centres(:,:,c)];
 
end
% --> TODO <-- %
%% III.3. Build Matrix XiYiZi (use the information from the file: information_calibration_pattern.txt)
xyz=[];
k=1;
z=[0 17 30 43 57];% z vale from the .txt file
for c=1:5
    for d=0:7
        for e=0:5
            XYZ(k,:)=[d*17,e*17,z(c)];
            k=k+1;
        end
    end
end
        

figure(5);
plot3(XYZ(:,1),-XYZ(:,2),XYZ(:,3),'+');hold on;plot3(XYZ(:,1),-XYZ(:,2),XYZ(:,3),'m');xlabel('X(mm)');ylabel('-Y(mm)');zlabel('Z(mm)');title('Amers dans le repère mire (Xi,Yi,Zi)');
% Build and save matrix XYZuv to compute the calibration matrix
XYZuv=[XYZ,uivi];
save ('XYZuv.mat', 'XYZuv');

%% IV. Matrix calibration computation

% IV.1 Matrix calibration computation Call functions createBC() and createM() to compute the calibration matrix M.
[B,C]=createBC(XYZuv);
M=createM(B,C);

% IV.2 Check the contains and display your comment accordingly
 Check = sqrt(M(3,1)^2+M(3,2)^2+M(3,3)^2);
 fprintf('Faugeras and Toscani constraint is used')

%% V. Validity of the calibration matrix

% V.1. Re-projection
% Create homogeneous coordinates
XYZ1=[XYZ';ones(1,size(XYZ,1))];

% Re-project and scale appropriately
u_v=[M*XYZ1] 
% --> TODO <-- %
u_v(:,1)=u_v(:,1)./u_v(:,3);
u_v(:,2)=u_v(:,2)./u_v(:,3);
u_v(:,3)=u_v(:,3)./u_v(:,3);

%% V.2. Display
uivia=uivi'; % Actual 2D coordinates
uivir=u_v;
N=48;


%figure;
for c=1:5
    imshow(I(:,:,c),[]);colorbar;
    hold on; plot(uivia(1,1+(c-1)*N:c*N),uivia(2,1+(c-1)*N:c*N),'+');
    plot(uivir(1,1+(c-1)*N:c*N),uivir(2,1+(c-1)*N:c*N),'*m');title('Images of patterns + amers reprojetés + detected landmarks');pause(0.5)
end


figure (6);
imshow(I(:,:,1),[]);colorbar;
for c=1:5
    hold on; plot(uivia(1,1+(c-1)*N:c*N),uivia(2,1+(c-1)*N:c*N),'+');
    plot(uivir(1,1+(c-1)*N:c*N),uivir(2,1+(c-1)*N:c*N),'*m');title('Images of patterns + detected landmarks');pause(0.5)
end

%% V.3. Compute the mean difference and the standard deviation of the distribution of differences and save it

ecarts=[];
% Compute the re-projection error / distance
first=uivia';
second=uivir(1:2,:)';
distance=first-second;
ecarts=sqrt((distance(:,1)).^2+(distance(:,2)).^2);


figure (7);
hist(ecarts,24);title('Histogram of differences')

% compute average and standard deviation of the error/distance
average = mean(ecarts);
standard = std(ecarts);

%% V.4. Intrinsic and extrinsic parameters
IntrinsicExtrinsicParameters