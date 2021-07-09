location = 'C:\Users\DELL\Documents\deekshith\kode4u car number plate dectection\img';       %  folder in which your images exists
ds = imageDatastore(location);         %  Creates a datastore for all images in your folder
while hasdata(ds) 
    im = read(ds) ;% read image from datastore
  figure, imshow(im); % creates a new window for each image
im = imresize(im, [480 NaN]);
imgray = rgb2gray(im);
imbin = imbinarize(imgray);
im = edge(imgray, 'sobel');


im = imdilate(im, strel('diamond', 2));
im = imfill(im, 'holes');
im = imerode(im, strel('diamond', 10));


Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

%all above step are to find location of number plate

im = imcrop(imbin, boundingBox);

%resize number plate to 240 NaN
im = imresize(im, [240 NaN]);

%clear dust
im = imopen(im, strel('rectangle', [4 4]));

%remove some object if it width is too long or too small than 500
im = bwareaopen(~im, 500);
%%%get width
 [h, w] = size(im);
% Iprops=regionprops(im,'BoundingBox','Area', 'Image');
% image = Iprops.Image;
% count = numel(Iprops);
% for i=1:count
%    ow = length(Iprops(i).Image(1,:));
%    if ow<(h/2) 
%         im = im .* ~Iprops(i).Image;
%    end
% end  


imshow(im);


%read letter
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
count = numel(Iprops);

noPlate=[]; % Initializing the variable of number plate string.

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) && oh>(h/3)
       letter=readLetter(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       figure; imshow(Iprops(i).Image);
       noPlate=[noPlate letter]; % Appending every subsequent character in noPlate variable.
   end
end
b=noPlate;
d="hello mr.";
e=" your vehicle no "; 
f=" punished with challan for breaking traffic rules better to pay thorugh tsstrc.com";
T = readtable('data.xlsx','ReadRowNames',true);
a=T(b,1);
c=string(table2cell(T(b,2)));
g=d+c+e+(string(b))+f;
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail','thirunagarudeekshith@gmail.com');
setpref('Internet','SMTP_Username','thirunagarudeekshith@gmail.com');
setpref('Internet','SMTP_Password','6303858133');
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
sendmail(string(table2cell(a)),"traffic challan",g);
end
