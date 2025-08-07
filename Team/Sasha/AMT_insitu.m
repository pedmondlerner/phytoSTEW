%Sasha Kramer
%Boston University
%20250805

%%%PACE hackweek - AMT data
cd /Users/skramer/Documents/BU/PACE/Hackweek/Data
load AMT_FCM_HPLC_nut_POC.mat

AMT_FCM(AMT_FCM.Depth>10,:) = [];

for i = 2:740
    if AMT_FCM.Lat(i-1)==AMT_FCM.Lat(i)
        ind(i,1) = 1;
    end
end
clear i

ind(738:740) = 0;
AMT_FCM(ind==1,:) = [];
clear ind

writetable(AMT_FCM,'AMT_surf_FCM.csv');

%Cphyto from Martinez-Vincente et al., 2013
%Pro = 0.68um, 214 fgC mm^-3 x # of cells --> results in fgC
%Syn = 1.22, 203
%Pico = 1.56, 220
%Nano = 4.3, 220
%Crypto = 5.9, 220
%Cocco = 6.07, 285

Pro = ((AMT_FCM.Pro*1000*1000)*((1/6)*pi*(0.68^3)*214))./10^12;
Syn = ((AMT_FCM.Syn*1000*1000)*((1/6)*pi*(1.22^3)*203))./10^12;
Pico = ((AMT_FCM.Pico*1000*1000)*((1/6)*pi*(1.56^3)*220))./10^12;
Nano = ((AMT_FCM.Nano*1000*1000)*((1/6)*pi*(4.3^3)*220))./10^12;
Crypto = ((AMT_FCM.Cryptos*1000*1000)*((1/6)*pi*(5.9^3)*220))./10^12;
Cocco = ((AMT_FCM.Coccos*1000*1000)*((1/6)*pi*(6.07^3)*220))./10^12;

AMT_all_Cphyto = nansum([Pro Syn Pico Nano Crypto Cocco],2);
AMT_Cphyto = table(AMT_FCM.Cruise,AMT_FCM.Lat,AMT_FCM.Lon,AMT_FCM.Depth,Pro,Syn,Pico,Nano,Crypto,Cocco,AMT_all_Cphyto,'VariableNames',["Cruise","Latitude (degrees N)","Longitude (degrees E)","Depth","Prochlorococcus carbon (mgC m^-3)","Synechococcus carbon","Picoeukaryote carbon","Nanoeukaryote carbon","Cryptophyte carbon","Coccolithophore carbon","Summed phytoplankton carbon from flow cytometry"]);
writetable(AMT_Cphyto,'AMT_surf_Cphyto.csv');
clear Pro Syn Pico Nano Crypto Cocco

AMT_HPLC(AMT_HPLC.Depth>10,:) = [];

for i = 2:605
    if AMT_HPLC.Lat(i-1)==AMT_HPLC.Lat(i)
        ind(i,1) = 1;
    end
end
clear i

ind(503:605) = 0;
AMT_HPLC(ind==1,:) = [];
clear ind

writetable(AMT_HPLC,'AMT_surf_HPLC.csv');

AMT_nutrients(AMT_nutrients.Depth>10,:) = [];

for i = 2:879
    if AMT_nutrients.Lat(i-1)==AMT_nutrients.Lat(i)
        ind(i,1) = 1;
    end
end
clear i

ind(877:879) = 0;
AMT_nutrients(ind==1,:) = [];
clear ind

writetable(AMT_nutrients,'AMT_surf_nutrients.csv');

AMT_POC(AMT_POC.Depth>10,:) = [];

for i = 2:1863
    if AMT_POC.Lat(i-1)==AMT_POC.Lat(i)
        ind(i,1) = 1;
    end
end
clear i

ind(1863) = 0;
AMT_POC(ind==1,:) = [];
clear ind

writetable(AMT_POC,'AMT_surf_POC.csv');

%%%Match up samples and get ready to do EOFs
cd /Users/skramer/Documents/BU/PACE/Hackweek/Data/AMT_TS
load AMT_surf_TS.mat

%Probably easiest to do this by cruise
AMT18_FCM = AMT_FCM(1:54,:);
AMT19_FCM = AMT_FCM(55:130,:);
AMT20_FCM = AMT_FCM(131:195,:);
AMT22_FCM = AMT_FCM(196:268,:);
AMT24_FCM = AMT_FCM(269:336,:);
AMT25_FCM = AMT_FCM(337:409,:);
AMT28_FCM = AMT_FCM(410:471,:);

AMT18_Cphyto = AMT_Cphyto(1:54,:);
AMT19_Cphyto = AMT_Cphyto(55:130,:);
AMT20_Cphyto = AMT_Cphyto(131:195,:);
AMT22_Cphyto = AMT_Cphyto(196:268,:);
AMT24_Cphyto = AMT_Cphyto(269:336,:);
AMT25_Cphyto = AMT_Cphyto(337:409,:);
AMT28_Cphyto = AMT_Cphyto(410:471,:);

AMT18_HPLC = AMT_HPLC(1:48,:);
AMT19_HPLC = AMT_HPLC(49:139,:);
AMT20_HPLC = AMT_HPLC(140:199,:);
AMT22_HPLC = AMT_HPLC(200:393,:);
AMT24_HPLC = AMT_HPLC(394:419,:);
AMT25_HPLC = AMT_HPLC(420:480,:);
AMT28_HPLC = AMT_HPLC(481:538,:);

AMT18_POC = AMT_POC(1:159,:);
AMT19_POC = AMT_POC(160:334,:);
AMT20_POC = AMT_POC(335:528,:);
AMT22_POC = AMT_POC(529:683,:);
AMT24_POC = AMT_POC(684:857,:);
AMT25_POC = AMT_POC(858:990,:);
AMT28_POC = AMT_POC(991:1700,:);

AMT18_nutrients = AMT_nutrients(1:54,:);
AMT19_nutrients = AMT_nutrients(55:121,:);
AMT20_nutrients = AMT_nutrients(122:184,:);
AMT22_nutrients = AMT_nutrients(185:257,:);
AMT24_nutrients = AMT_nutrients(258:325,:);
AMT25_nutrients = AMT_nutrients(326:393,:);
AMT28_nutrients = AMT_nutrients(394:455,:);

AMT18_TS = AMT_TS(1:100,:);
AMT19_TS = AMT_TS(101:220,:);
AMT20_TS = AMT_TS(221:309,:);
AMT22_TS = AMT_TS(310:381,:);
AMT24_TS = AMT_TS(382:58993,:);
AMT25_TS = AMT_TS(58994:199965,:);
AMT28_TS = AMT_TS(199966:233296,:);

AMT18_TSlat = AMT_lat(1:100,:);
AMT19_TSlat = AMT_lat(101:220,:);
AMT20_TSlat = AMT_lat(221:309,:);
AMT22_TSlat = AMT_lat(310:381,:);
AMT24_TSlat = AMT_lat(382:58993,:);
AMT25_TSlat = AMT_lat(58994:199965,:);
AMT28_TSlat = AMT_lat(199966:233296,:);

%AMT18
for i = 1:48
    for j = 1:54
        amt_latI(j,i) = abs(AMT18_FCM.Lat(j,1)-AMT18_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT18_FCM_HPLC = AMT18_FCM(amt_ind,:);
AMT18_Cphyto_HPLC = AMT18_Cphyto(amt_ind,:);
clear AMT18_FCM AMT18_Cphyto amt_ind amt_min

for i = 1:48
    for j = 1:54
        amt_latI(j,i) = abs(AMT18_nutrients.Lat(j,1)-AMT18_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT18_nuts_HPLC = AMT18_nutrients(amt_ind,:);
clear AMT18_nutrients amt_ind amt_min

for i = 1:48
    for j = 1:100
        amt_latI(j,i) = abs(AMT18_TSlat(j,1)-AMT18_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT18_TS_HPLC = AMT18_TS(amt_ind,:);
clear AMT18_TS amt_ind amt_min AMT18_TSlat

for i = 1:48
    for j = 1:159
        amt_latI(j,i) = abs(AMT18_POC.Lat(j,1)-AMT18_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT18_POC_HPLC = AMT18_POC(amt_ind,:);
clear AMT18_POC amt_ind amt_min

%AMT19
for i = 1:76
    for j = 1:91
        amt_latI(j,i) = abs(AMT19_HPLC.Lat(j,1)-AMT19_FCM.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

ii = find(amt_min>0.1);
amt_ind(ii) = [];
amt_min(ii) = [];

AMT19_FCM_HPLC = AMT19_FCM;
AMT19_FCM_HPLC(ii,:) = [];
AMT19_HPLC = AMT19_HPLC(amt_ind,:);
AMT19_Cphyto_HPLC = AMT19_Cphyto;
AMT19_Cphyto_HPLC(ii,:) = [];
clear AMT19_FCM AMT19_Cphyto amt_ind amt_min ii

for i = 1:38
    for j = 1:67
        amt_latI(j,i) = abs(AMT19_nutrients.Lat(j,1)-AMT19_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

ii = find(amt_min>0.5);
amt_ind(ii) = [];
amt_min(ii) = [];

AMT19_nuts_HPLC = AMT19_nutrients(amt_ind,:);
AMT19_Cphyto_HPLC(ii,:) = [];
AMT19_FCM_HPLC(ii,:) = [];
AMT19_HPLC(ii,:) = [];
clear AMT19_nutrients amt_ind amt_min ii

for i = 1:36
    for j = 1:120
        amt_latI(j,i) = abs(AMT19_TSlat(j,1)-AMT19_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT19_TS_HPLC = AMT19_TS(amt_ind,:);
clear AMT19_TS amt_ind amt_min AMT19_TSlat

for i = 1:36
    for j = 1:175
        amt_latI(j,i) = abs(AMT19_POC.Lat(j,1)-AMT19_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT19_POC_HPLC = AMT19_POC(amt_ind,:);
clear AMT19_POC amt_ind amt_min

%AMT20
for i = 1:60
    for j = 1:63
        amt_latI(j,i) = abs(AMT20_nutrients.Lat(j,1)-AMT20_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

ii = find(amt_min>0.1);
amt_ind(ii) = [];
amt_min(ii) = [];

AMT20_nutrients_HPLC = AMT20_nutrients(amt_ind,:);
AMT20_HPLC(ii,:) = [];
clear AMT20_nutrients amt_ind amt_min ii

for i = 1:59
    for j = 1:65
        amt_latI(j,i) = abs(AMT20_FCM.Lat(j,1)-AMT20_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT20_FCM_HPLC = AMT20_FCM(amt_ind,:);
AMT20_Cphyto_HPLC = AMT20_Cphyto(amt_ind,:);
clear AMT20_FCM AMT20_Cphyto amt_ind amt_min ii

for i = 1:59
    for j = 1:89
        amt_latI(j,i) = abs(AMT20_TSlat(j,1)-AMT20_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT20_TS_HPLC = AMT20_TS(amt_ind,:);
clear AMT20_TS amt_ind amt_min AMT20_TSlat

for i = 1:59
    for j = 1:194
        amt_latI(j,i) = abs(AMT20_POC.Lat(j,1)-AMT20_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT20_POC_HPLC = AMT20_POC(amt_ind,:);
clear AMT20_POC amt_ind amt_min

%AMT22
for i = 1:73
    for j = 1:194
        amt_latI(j,i) = abs(AMT22_HPLC.Lat(j,1)-AMT22_FCM.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT22_HPLC = AMT22_HPLC(amt_ind,:);
clear amt_ind amt_min

for i = 1:72
    for j = 1:73
        amt_latI(j,i) = abs(AMT22_HPLC.Lat(j,1)-AMT22_TSlat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT22_TS_HPLC = AMT22_TS(2:end,:);
AMT22_Cphyto = AMT22_Cphyto(amt_ind(2:end),:);
AMT22_HPLC = AMT22_HPLC(amt_ind(2:end),:);
AMT22_FCM = AMT22_FCM(amt_ind(2:end),:);
AMT22_nutrients = AMT22_nutrients(amt_ind(2:end),:);
clear AMT22_TS amt_ind amt_min AMT22_TSlat

for i = 1:71
    for j = 1:155
        amt_latI(j,i) = abs(AMT22_POC.Lat(j,1)-AMT22_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

amt_ind(50) = [];

AMT22_POC_HPLC = AMT22_POC(amt_ind,:);
AMT22_TS_HPLC(50,:) = [];
AMT22_Cphyto(50,:) = [];
AMT22_FCM(50,:) = [];
AMT22_HPLC(50,:) = [];
AMT22_nutrients(50,:) = [];
clear AMT22_POC amt_ind amt_min

%AMT24
for i = 1:26
    for j = 1:68
        amt_latI(j,i) = abs(AMT24_FCM.Lat(j,1)-AMT24_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT24_FCM = AMT24_FCM(amt_ind,:);
AMT24_Cphyto = AMT24_Cphyto(amt_ind,:);
AMT24_nutrients = AMT24_nutrients(amt_ind,:);
clear amt_ind amt_min

for i = 1:26
    for j = 1:174
        amt_latI(j,i) = abs(AMT24_POC.Lat(j,1)-AMT24_FCM.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT24_POC = AMT24_POC(amt_ind,:);
clear amt_ind amt_min

for i = 1:26
    for j = 1:58612
        amt_latI(j,i) = abs(AMT24_TSlat(j,1)-AMT24_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT24_TS = AMT24_TS(amt_ind,:);
clear AMT24_TSlat amt_ind amt_min

%AMT25
for i = 1:61
    for j = 1:68
        amt_latI(j,i) = abs(AMT25_nutrients.Lat(j,1)-AMT25_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

ii = find(amt_min>0.5);
amt_ind(ii) = [];

AMT25_nutrients = AMT25_nutrients(amt_ind,:);
AMT25_HPLC(ii,:) = [];
clear amt_ind amt_min ii

for i = 1:57
    for j = 1:73
        amt_latI(j,i) = abs(AMT25_FCM.Lat(j,1)-AMT25_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT25_FCM = AMT25_FCM(amt_ind(2:end),:);
AMT25_Cphyto = AMT25_Cphyto(amt_ind(2:end),:);
AMT25_HPLC = AMT25_HPLC(2:end,:);
AMT25_nutrients = AMT25_nutrients(2:end,:);
clear amt_ind amt_min

for i = 1:56
    for j = 1:133
        amt_latI(j,i) = abs(AMT25_POC.Lat(j,1)-AMT25_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

ii = find(amt_min>0.5);
amt_ind(ii) = [];

AMT25_POC = AMT25_POC(amt_ind,:);
AMT25_HPLC(ii,:) = [];
AMT25_Cphyto(ii,:) = [];
AMT25_FCM(ii,:) = [];
AMT25_nutrients(ii,:) = [];
clear amt_ind amt_min ii

for i = 1:45
    for j = 1:140972
        amt_latI(j,i) = abs(AMT25_TSlat(j,1)-AMT25_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT25_TS = AMT25_TS(amt_ind,:);
clear AMT25_TSlat amt_ind amt_min

%AMT28
AMT28_FCM(1,:) = [];
AMT28_Cphyto(1,:) = [];
AMT28_nutrients(1,:) = [];

for i = 1:58
    for j = 1:61
        amt_latI(j,i) = abs(AMT28_FCM.Lat(j,1)-AMT28_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

ii = find(amt_min>0.5);
amt_ind(ii) = [];

AMT28_nutrients = AMT28_nutrients(amt_ind,:);
AMT28_FCM = AMT28_FCM(amt_ind,:);
AMT28_Cphyto = AMT28_Cphyto(amt_ind,:);
AMT28_HPLC(ii,:) = [];
clear amt_ind amt_min ii

for i = 1:27
    for j = 1:710
        amt_latI(j,i) = abs(AMT28_POC.Lat(j,1)-AMT28_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT28_POC = AMT28_POC(amt_ind,:);
clear amt_ind amt_min

for i = 1:27
    for j = 1:33331
        amt_latI(j,i) = abs(AMT28_TSlat(j,1)-AMT28_HPLC.Lat(i,1));
    end
end
[amt_min,amt_ind] = min(amt_latI);
clear amt_latI i j

AMT28_TS = AMT28_TS(amt_ind,:);
clear AMT28_TSlat amt_ind amt_min

%Put everything together
AMT_match_Cphyto = [AMT18_Cphyto_HPLC;AMT19_Cphyto_HPLC;AMT20_Cphyto_HPLC;AMT22_Cphyto;AMT24_Cphyto;AMT25_Cphyto;AMT28_Cphyto];
AMT_match_FCM = [AMT18_FCM_HPLC;AMT19_FCM_HPLC;AMT20_FCM_HPLC;AMT22_FCM;AMT24_FCM;AMT25_FCM;AMT28_FCM];
AMT_match_HPLC = [AMT18_HPLC;AMT19_HPLC;AMT20_HPLC;AMT22_HPLC;AMT24_HPLC;AMT25_HPLC;AMT28_HPLC];
AMT_match_POC = [AMT18_POC_HPLC;AMT19_POC_HPLC;AMT20_POC_HPLC;AMT22_POC_HPLC;AMT24_POC;AMT25_POC;AMT28_POC];
AMT_match_nutrients = [AMT18_nuts_HPLC;AMT19_nuts_HPLC;AMT20_nutrients_HPLC;AMT22_nutrients;AMT24_nutrients;AMT25_nutrients;AMT28_nutrients];
AMT_match_TS = [AMT18_TS_HPLC;AMT19_TS_HPLC;AMT20_TS_HPLC;AMT22_TS_HPLC;AMT24_TS;AMT25_TS;AMT28_TS];
clear AMT18* AMT19* AMT20* AMT22* AMT24* AMT25* AMT28*

figure('Color','white'),clf
ax = worldmap([-58 59],[-180 100]);
load coastlines
setm(gca,'mapprojection','winkel')
plotm(coastlat,coastlon,'k','LineWidth',1.5)
%gridm('off')
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8])
hold on
scatterm(AMT_match_POC.Lat,AMT_match_POC.Lon,80,AMT_match_POC.Cruise,'filled'),colorbar
clim([1 8])
h = colorbar('Ticks',[1.5 2.5 3.5 4.5 5.5 6.5 7.5],'TickLabels',["AMT18","AMT19","AMT20","AMT22","AMT24","AMT25","AMT28"]);
colormap(turbo(7))
set(h,'fontsize',30)
setm(ax,'mlabelparallel',-90,'plabelmeridian','west','fontsize',30,'fontweight','bold','mlabellocation',[-180 -90 0 90 180],'plabellocation',[-50 -25 0 25 50])
clear ax h coastlat coastlon c i b1 b2 b3 l

%Fix POC units
AMT_match_POC.POC(49:284,:) = AMT_match_POC.POC(49:284,:)*1000;
AMT_match_POC.POC(285:end,:) = AMT_match_POC.POC(285:end,:)*12;

%Pigment clustering
AMT_mm_HPLC = table2array(AMT_match_HPLC(:,6:24));
for i = 1:311
    for j = [1,2,4,5,6,7,11,18,19]
        if AMT_mm_HPLC(i,j) == 0.001
            AMT_mm_HPLC(i,j) = 0;
        end
    end
end
clear i j

AMT_match_HPLC(:,6:24) = array2table(AMT_mm_HPLC);

labels = {'Allo','ABcaro','ButFuco','Chlc12','Chlc3','Diadino','Diato','DVchla','Fuco','HexFuco','Lut','Neo','Perid','Pras','Tchla','Tchlb','Tchlc','Viola','Zea'};

for i = 1:19
    belowD = find(AMT_mm_HPLC(:,i) <= 0.001);
    j(i) = length(belowD);
    percent(i) = 100*(j(i)./311);
end
clear belowD i j

%Remove redundant pigs (Tchlb, Tchlc, ABcaro, MVchla)
%Allo, Diato, Lut, Neo, Pras, Viola 60-80% below
%Lut, Pras also below detection >75%//DVchlb 73%
deg2 = [2,6,7,12,11,14,15,17];
Rpigcluster2 = AMT_mm_HPLC;
Rpigcluster2(:,deg2) = [];

label2 = labels;
label2(deg2) = [];
D2 = pdist(Rpigcluster2','correlation'); %correlation
Z2 = linkage(D2,'ward');

figure(2),clf
h = dendrogram(Z2,'Labels',label2);
set(gca,'XTickLabelRotation',90,'fontsize',18)
set(h,'color','k','linewidth',2)
ylabel('Linkage Distance')
ax = gca;
ax.YGrid = 'on';
box on
clear ax h

%Normalize to chlorophyll-a
normchl = Rpigcluster2./AMT_mm_HPLC(:,15);

D3 = pdist(normchl','correlation'); %correlation
Z3 = linkage(D3,'ward');
%lo = optimalleaforder(Z3,D3);
%lom = [2,1,10,9,4,5,8,11,12,3,7,6];

figure(3),clf
%h = dendrogram(Z3,'reorder',lom,'Labels',normlabel);
h = dendrogram(Z3,'Labels',label2);
set(gca,'XTickLabelRotation',90,'fontsize',20)
set(h,'color','k','linewidth',2)
ylabel('Linkage Distance')
ax = gca;
ax.YGrid = 'on';
box on
clear ax h D2 D3 deg deg2 labels Z2 Z3

%Pigments + FCM
AMT_mm_FCM = table2array(AMT_match_FCM(:,6:end));
AMT_norm_FCM = AMT_mm_FCM./nansum(AMT_mm_FCM,2);
AMT_norm_FCM(isnan(AMT_norm_FCM)) = 0;
pig_fcm = [normchl,AMT_norm_FCM(:,3:5)];

labelf = label2;
labelf(12:14) = {'{\itProchlorococcus}','{\itSynechococcus}','Picoeuks'};

D4 = pdist(pig_fcm','correlation'); %correlation
Z4 = linkage(D4,'ward');

figure(4),clf
h = dendrogram(Z4,'Labels',labelf);
set(gca,'XTickLabelRotation',90,'fontsize',20)
set(h,'color','k','linewidth',2)
ylabel('Linkage Distance')
ax = gca;
ax.YGrid = 'on';
box on
clear ax h D4 Z4

%Latitudinal plots and scatter plots between variables
figure(5),clf
subplot(1,3,1)
scatter(log10(AMT_match_HPLC.tot_chl_a),AMT_match_HPLC.Lat,100,AMT_match_HPLC.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('log_{10} HPLC total chlorophyll-{\ita} (mg m^{-3})')
ylabel('Latitude (^oN)')
box on
axis square
axis([-2 1 -55 55])

subplot(1,3,2)
scatter(AMT_match_POC.POC,AMT_match_POC.Lat,100,AMT_match_POC.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('POC (mg m^{-3})')
ylabel('Latitude (^oN)')
box on
axis square
axis([0 600 -55 55])

subplot(1,3,3)
scatter(AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),AMT_match_Cphyto.("Latitude (degrees N)"),100,AMT_match_Cphyto.Cruise,'filled')
hold on
clim([1 8])
h = colorbar('Ticks',[1.5 2.5 3.5 4.5 5.5 6.5 7.5],'TickLabels',["AMT18","AMT19","AMT20","AMT22","AMT24","AMT25","AMT28"]);
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('Summed phytoplankton carbon from {\newline}flow cytometry (mg m^{-3})')
ylabel('Latitude (^oN)')
box on
axis square
axis([0 180 -55 55])

for i = 1:311
    if AMT_match_nutrients.NitrateNitrite(i)<AMT_match_nutrients.Nitrite(i)
        AMT_mm_nitrate(i,1) = AMT_match_nutrients.Nitrite(i);
    else AMT_mm_nitrate(i,1) = AMT_match_nutrients.NitrateNitrite(i);
    end
end

figure(6),clf
subplot(1,3,1)
scatter(log10(AMT_match_HPLC.tot_chl_a),AMT_match_HPLC.Lat,100,AMT_match_HPLC.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('log_{10} HPLC total chlorophyll-{\ita} (mg m^{-3})')
ylabel('Latitude (^oN)')
box on
axis square
axis([-2 1 -55 55])

subplot(1,3,2)
scatter(AMT_mm_nitrate,AMT_match_nutrients.Lat,100,AMT_match_nutrients.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('Nitrate ({\mu}mol L^{-1})')
ylabel('Latitude (^oN)')
box on
axis square
axis([0 15 -55 55])

subplot(1,3,3)
scatter(AMT_match_TS(:,1),AMT_match_nutrients.Lat,100,AMT_match_nutrients.Cruise,'filled')
hold on
clim([1 8])
h = colorbar('Ticks',[1.5 2.5 3.5 4.5 5.5 6.5 7.5],'TickLabels',["AMT18","AMT19","AMT20","AMT22","AMT24","AMT25","AMT28"]);
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('Temperature (^oC)')
ylabel('Latitude (^oN)')
box on
axis square
axis([-5 30 -55 55])

figure(7),clf
subplot(1,3,1)
scatter(AMT_match_FCM.Pro,AMT_match_FCM.Lat,100,AMT_match_FCM.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('{\itProchlorococcus} spp. (cells mL^{-1})')
ylabel('Latitude (^oN)')
box on
axis square
axis([0 6*10^5 -55 55])

subplot(1,3,2)
scatter(AMT_match_FCM.Syn,AMT_match_FCM.Lat,100,AMT_match_FCM.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('{\itSynechococcus} spp. (cells mL^{-1})')
ylabel('Latitude (^oN)')
box on
axis square
axis([0 4*10^5 -55 55])

subplot(1,3,3)
scatter(AMT_match_FCM.Pico,AMT_match_FCM.Lat,100,AMT_match_FCM.Cruise,'filled')
hold on
clim([1 8])
h = colorbar('Ticks',[1.5 2.5 3.5 4.5 5.5 6.5 7.5],'TickLabels',["AMT18","AMT19","AMT20","AMT22","AMT24","AMT25","AMT28"]);
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('Picoeukaryote (cells mL^{-1})')
ylabel('Latitude (^oN)')
box on
axis square
axis([0 10^5 -55 55])

figure(8),clf
subplot(1,2,1)
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_POC.POC,100,AMT_match_POC.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('HPLC total chlorophyll-{\ita} (mg m^{-3})')
ylabel('POC (mg m^{-3})')
box on
axis square

subplot(1,2,2)
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),100,AMT_match_HPLC.Cruise,'filled')
hold on
clim([1 8])
h = colorbar('Ticks',[1.5 2.5 3.5 4.5 5.5 6.5 7.5],'TickLabels',["AMT18","AMT19","AMT20","AMT22","AMT24","AMT25","AMT28"]);
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('HPLC total chlorophyll-{\ita} (mg m^{-3})')
ylabel(sprintf('Summed phytoplankton carbon from \nflow cytometry (mg m^{-3})'))
box on
axis square

addpath(genpath('/Users/skramer/Documents/MATLAB'))

figure(9),clf
subplot(1,3,1)
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),120,'k','filled')
hold on
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),100,AMT_norm_FCM(:,4),'filled')
clim([0 1])
cmocean('algae')
title('{\itProchlorococcus} spp.')
set(gca,'fontsize',20)
xlabel('HPLC total chlorophyll-{\ita} (mg m^{-3})')
ylabel(sprintf('Summed phytoplankton carbon from \nflow cytometry (mg m^{-3})'))
box on
axis square

subplot(1,3,2)
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),120,'k','filled')
hold on
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),100,AMT_norm_FCM(:,3),'filled')
clim([0 1])
cmocean('algae')
title('{\itSynechococcus} spp.')
set(gca,'fontsize',20)
xlabel('HPLC total chlorophyll-{\ita} (mg m^{-3})')
ylabel(sprintf('Summed phytoplankton carbon from \nflow cytometry (mg m^{-3})'))
box on
axis square

subplot(1,3,3)
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),120,'k','filled')
hold on
scatter(AMT_match_HPLC.tot_chl_a,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),100,AMT_norm_FCM(:,5),'filled')
clim([0 1])
h = colorbar;
cmocean('algae')
ylabel(h,'Fraction of FCM cells') 
title('Picoeukaryotes')
set(gca,'fontsize',20)
xlabel('HPLC total chlorophyll-{\ita} (mg m^{-3})')
ylabel(sprintf('Summed phytoplankton carbon from \nflow cytometry (mg m^{-3})'))
box on
axis square

%Correlation matrix
AMT_norm_HPLC = AMT_mm_HPLC./AMT_mm_HPLC(:,15);
total = [AMT_match_HPLC.tot_chl_a,AMT_match_POC.POC,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),AMT_mm_nitrate,AMT_match_TS(:,1),AMT_mm_HPLC(:,9),AMT_mm_HPLC(:,16),AMT_mm_HPLC(:,3),AMT_mm_HPLC(:,10),AMT_mm_HPLC(:,13),AMT_mm_HPLC(:,8),AMT_mm_HPLC(:,19),AMT_mm_FCM(:,3:5)];
normalized = [AMT_match_HPLC.tot_chl_a,AMT_match_POC.POC,AMT_match_Cphyto.("Summed phytoplankton carbon from flow cytometry"),AMT_mm_nitrate,AMT_match_TS(:,1),AMT_norm_HPLC(:,9),AMT_norm_HPLC(:,16),AMT_norm_HPLC(:,3),AMT_norm_HPLC(:,10),AMT_norm_HPLC(:,13),AMT_norm_HPLC(:,8),AMT_norm_HPLC(:,19),AMT_norm_FCM(:,3:5)];

total(isnan(total)) = 0;
normalized(isnan(normalized)) = 0;

corrtot = corrcoef(total);
corrnorm = corrcoef(normalized);
labelyp = {'Tchla','POC','Cphyto','Nitrate','SST','Fuco (diatoms)','Tchlb (chlorophytes)','19but (haptophytes)','19hex (haptophytes)','Perid (dinos)','DVchla (Pro)','Zea (cyanos)','{\itSynechococcus}','{\itProchlorococcus}','Picoeukaryotes'};
labelxp = {'Tchla','POC','Cphyto','Nitrate','SST','Fuco/Tchla (diatoms)','Tchlb/Tchla (chlorophytes)','19but/Tchla (haptophytes)','19hex/Tchla (haptophytes)','Perid/Tchla (dinos)','DVchla/Tchla (Pro)','Zea/Tchla (cyanos)','Frac {\itSynechococcus}','Frac {\itProchlorococcus}','Frac picoeukaryotes'};

addpath(genpath('/Users/skramer/Documents/WHOI/SSF/LOM_Paper/Variables/kakearney-cptcmap-pkg-845bf83/cptcmap/'))

chlNS = tril(corrtot);
chlS = triu(corrnorm);
chl_chlNS = chlS+chlNS;
for i = 1:15
    chl_chlNS(i,i) = 1;
end

chl_chlNS_nan = chl_chlNS;
for i = 1:15
    chl_chlNS_nan(i,i) = NaN;
end
clear i

chl_chlNS_space = num2str(chl_chlNS_nan(:),'%0.2f');
chl_chlNS_ind = str2num(chl_chlNS_space);
ind = find(isnan(chl_chlNS_ind) == 1);
chl_chlNS_space(ind,:) = [' '];

figure('Color','w')
imagesc(chl_chlNS_nan,'AlphaData',~isnan(chl_chlNS_nan))
h = colorbar;
xticks([1:1:15]);
xticklabels(labelxp);
yticks([1:1:15]);
yticklabels(labelyp);
ylabel(h,'Correlation coefficient','fontsize',16)
caxis([-1 1])
textStrings = chl_chlNS_space;  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
[x,y] = meshgrid(1:15,1:15);
hStrings = text(x(:),y(:),textStrings(:),'HorizontalAlignment','center','fontweight','bold');
cptcmap('GMT_polar')
set(gca,'fontsize',15)
set(h,'fontsize',20);
clear hStrings ind x y textStrings h

figure(11),clf
subplot(1,2,1)
scatter(AMT_match_TS(:,1),AMT_mm_nitrate,100,AMT_match_POC.Cruise,'filled')
hold on
clim([1 8])
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('Sea surface temperature (^oC)')
ylabel('Nitrate ({\mu}mol L^{-1})')
box on
axis square

subplot(1,2,2)
scatter(AMT_mm_nitrate,AMT_match_HPLC.fuco,100,AMT_match_HPLC.Cruise,'filled')
hold on
clim([1 8])
h = colorbar('Ticks',[1.5 2.5 3.5 4.5 5.5 6.5 7.5],'TickLabels',["AMT18","AMT19","AMT20","AMT22","AMT24","AMT25","AMT28"]);
colormap(turbo(7))
set(gca,'fontsize',20)
ylabel('HPLC fucoxanthin (mg m^{-3})')
xlabel('Nitrate ({\mu}mol L^{-1})')
box on
axis square

figure(12),clf
subplot(1,3,1)
scatter(AMT_match_TS(:,1),AMT_norm_FCM(:,4),100,AMT_match_HPLC.Cruise,'filled')
hold on
clim([1 8])
set(gca,'fontsize',20)
xlabel('Sea surface temperature (^oC)')
ylabel('{\itProchlorococcus} spp. cells mL^{-1})')
box on
axis square

subplot(1,3,2)
scatter(AMT_match_TS(:,1),AMT_norm_FCM(:,3),100,AMT_match_HPLC.Cruise,'filled')
hold on
clim([1 8])
set(gca,'fontsize',20)
xlabel('Sea surface temperature (^oC)')
ylabel('{\itSynechococcus} spp. cells mL^{-1})')
box on
axis square

subplot(1,3,3)
scatter(AMT_match_TS(:,1),AMT_norm_FCM(:,5),100,AMT_match_HPLC.Cruise,'filled')
hold on
clim([1 8])
h = colorbar('Ticks',[1.5 2.5 3.5 4.5 5.5 6.5 7.5],'TickLabels',["AMT18","AMT19","AMT20","AMT22","AMT24","AMT25","AMT28"]);
colormap(turbo(7))
set(gca,'fontsize',20)
xlabel('Sea surface temperature (^oC)')
ylabel('Picoeukaryote cells mL^{-1})')
box on
axis square

%PCA
%Center log ratio transform the data
feat1 = normalized;
feat1(:,[8,11,12]) = [];
labelf = labelxp;
labelf([8,11,12]) = [];

labelf(10:11) = {'Frac Synechorococcus','Frac Prochlorococcus'};

feat1 = feat1+1;
feat1_clr = log(feat1./repmat(geomean(feat1,2),1,size(feat1,2)));

[EOFs_featf1,AFs_featf1,eigvalues_featf1] = pca(feat1_clr,'Centered',false,'Rows','complete'); 

EOFs_f1fp = EOFs_featf1(:,1:2);
AFs_f1fp = AFs_featf1(:,1:2);

colors = {'#E8ECFB', '#D9CCE3', '#D1BBD7', '#CAACCB', '#BA8DB4', '#AE76A3', '#AA6F9E', '#994F88', '#882E72', '#1965B0', '#437DBF', '#5289C7', '#6195CF', '#7BAFDE', '#4EB265', '#90C987', '#CAE0AB', '#F7F056', '#F7CB45', '#F6C141', '#F4A736', '#F1932D', '#EE8026', '#E8601C', '#E65518', '#DC050C', '#A5170E', '#72190E', '#42150A'};
colors = colors(:,[3,6,9,10,12,14,15,17,18,21,24,26]);
colrgb = hex2rgb(colors');

figure(13),clf
h2 = biplot(EOFs_f1fp,'VarLabels',labelf);
hold on
for i = 1:12
    h2(i).Color = colrgb(i,:);
    h2(i).LineWidth = 2;
end
clear i 
h = findobj(gca,"Tag","varlabel");
set(h,'fontsize',16)
set(gca,'fontsize',22)
axis square
box on

%EOFs for all variables
pigEOF = normalized;
pigEOF(:,[8,11,12]) = [];

pigmeans = nanmean(pigEOF);
pigstd = nanstd(pigEOF);
for i = 1:size(pigEOF,1);
    pigs_center(i,:) = (pigEOF(i,:) - pigmeans)./pigstd;
end
clear i

[EOFs_pig,AFs_pig,eigvalues_pig] = pca(pigs_center,'Centered',false,'Rows','complete'); 

var_explained = (eigvalues_pig(1:end)/sum(eigvalues_pig))';
var_cutoff = 0.05; 

%For plotting later on:
expvar = var_explained(var_explained>var_cutoff)';
expvar_percent = expvar.*100;
perc_exp = [expvar_percent cumsum(expvar_percent)]
expvar_str = num2str(expvar_percent,'%.1f%%s'); 

%Remove modes that don't explain much variance
%Keeping top 6 modes so everything less than 5% gets cut...
EOFs_pigC = EOFs_pig(:,var_explained>var_cutoff);
AFs_pigC = AFs_pig(:,var_explained>var_cutoff);

%Amplitude functions:
AF1p = AFs_pigC(:,1);
AF2p = AFs_pigC(:,2);
AF3p = AFs_pigC(:,3);
AF4p = AFs_pigC(:,4);
AF5p = AFs_pigC(:,5);
AF6p = AFs_pigC(:,6);

%Correlating AFs of each mode with pigments and pig:chl ratios
%Add latitude and longitude to check correlation with modes
corrmat = [AF1p,AF2p,AF3p,AF4p,AF5p,AF6p,pigEOF];
[R_pig,P_pig] = corrcoef(corrmat,'rows','pairwise');
%check here if EOF's are correlated with each other - the first 6 are not!

%Trim R_pig to only include correlations of pigments with AFs
R_pig_trim = R_pig(1:6,7:end); %6 is number of modes you want to keep/plot, 7 is that +1 --> change if you want to look at more modes
P_pig_trim = P_pig(1:6,7:end); %trims to only show correlations of AF's with pigments

%Prepare to make some plots
EOFs_rearr = EOFs_pigC;

R_pigR = R_pig_trim';
R_rearr = R_pigR;

labelf2 = labelf;
labelf2(10:11) = {'Frac {\itSynechococcus}','Frac {\itProchlorococcus}'};

ys = [-1 1];
xs = [0 (size(pigEOF,2)+1)]; 
figure(14),clf
hold on
for i = 1:12
    b1(i) = bar(i,EOFs_rearr(i,1));
    set(b1(i),'FaceColor',colrgb(i,:))
    hold on
end
clear i
set(gca,'XTick',1:length(EOFs_rearr),'XTickLabel',[]);
ylim(ys);
xlim(xs);
text(0.3,0.8,['Mode 1: ',expvar_str(1,1:5)],'FontSize',26,'FontWeight','bold') %add percent var to top right within plot
x = [1:1:(size(pigEOF,2)+1)]; %number of bars
y = ones(1,size(pigEOF,2))*-0.95; 
xticklabels(labelf2)
ax = gca;
ax.YGrid = 'on'; %adding horizontal grid lines
ax.XTickLabelRotation=45; 
ax.YTick = [-1:0.5:1];
set(gca,'fontsize',22)
box on
for i1=1:length(R_rearr)
    text(x(i1)-0.25,-0.85,num2str(R_rearr(i1,1)*100,'%0.0f'),'FontSize',15,'fontweight','bold')
end
clear b1*

figure(15),clf
hold on
for i = 1:12
    b1(i) = bar(i,EOFs_rearr(i,2));
    set(b1(i),'FaceColor',colrgb(i,:))
    hold on
end
clear i
set(gca,'XTick',1:length(EOFs_rearr),'XTickLabel',[]);
ylim(ys);
xlim(xs);
text(0.3,0.8,['Mode 2: ',expvar_str(2,1:5)],'FontSize',26,'FontWeight','bold') %add percent var to top right within plot
x = [1:1:(size(pigEOF,2)+1)]; %number of bars
y = ones(1,size(pigEOF,2))*-0.95; 
xticklabels(labelf2)
ax = gca;
ax.YGrid = 'on'; %adding horizontal grid lines
ax.XTickLabelRotation=45; 
ax.YTick = [-1:0.5:1];
set(gca,'fontsize',22)
box on
for i1=1:length(R_rearr)
    text(x(i1)-0.25,-0.85,num2str(R_rearr(i1,2)*100,'%0.0f'),'FontSize',15,'fontweight','bold')
end
clear b1*

figure(16),clf
hold on
for i = 1:12
    b1(i) = bar(i,EOFs_rearr(i,3));
    set(b1(i),'FaceColor',colrgb(i,:))
    hold on
end
clear i
set(gca,'XTick',1:length(EOFs_rearr),'XTickLabel',[]);
ylim(ys);
xlim(xs);
text(0.3,0.8,['Mode 3: ',expvar_str(3,1:5)],'FontSize',26,'FontWeight','bold') %add percent var to top right within plot
x = [1:1:(size(pigEOF,2)+1)]; %number of bars
y = ones(1,size(pigEOF,2))*-0.95; 
xticklabels(labelf2)
ax = gca;
ax.YGrid = 'on'; %adding horizontal grid lines
ax.XTickLabelRotation=45; 
ax.YTick = [-1:0.5:1];
set(gca,'fontsize',22)
box on
for i1=1:length(R_rearr)
    text(x(i1)-0.25,-0.85,num2str(R_rearr(i1,3)*100,'%0.0f'),'FontSize',15,'fontweight','bold')
end
clear ax b1* i i1 x xs y ys

%Global maps of AFs
figure('Color','white'),clf
ax = worldmap([-58 59],[-130 65]);
load coastlines
setm(gca,'mapprojection','winkel')
plotm(coastlat,coastlon,'k','LineWidth',1.5)
%gridm('off')
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8])
hold on
scatterm(AMT_match_POC.Lat,AMT_match_POC.Lon,80,AF1p,'filled'),colorbar
clim([-2 2])
h = colorbar;
cptcmap('GMT_polar')
ylabel(h,'Amplitude Function 1')
set(h,'fontsize',30)
setm(ax,'mlabelparallel',-90,'plabelmeridian','west','fontsize',30,'mlabellocation',[-120 -60 0 60 120],'plabellocation',[-50 -25 0 25 50])
clear ax h coastlat coastlon c i b1 b2 b3 l

figure('Color','white'),clf
ax = worldmap([-58 59],[-130 65]);
load coastlines
setm(gca,'mapprojection','winkel')
plotm(coastlat,coastlon,'k','LineWidth',1.5)
%gridm('off')
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8])
hold on
scatterm(AMT_match_POC.Lat,AMT_match_POC.Lon,80,AF2p,'filled'),colorbar
clim([-2 2])
h = colorbar;
cptcmap('GMT_polar')
ylabel(h,'Amplitude Function 2')
set(h,'fontsize',30)
setm(ax,'mlabelparallel',-90,'plabelmeridian','west','fontsize',30,'mlabellocation',[-120 -60 0 60 120],'plabellocation',[-50 -25 0 25 50])
clear ax h coastlat coastlon c i b1 b2 b3 l

figure('Color','white'),clf
ax = worldmap([-58 59],[-130 65]);
load coastlines
setm(gca,'mapprojection','winkel')
plotm(coastlat,coastlon,'k','LineWidth',1.5)
%gridm('off')
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8])
hold on
scatterm(AMT_match_POC.Lat,AMT_match_POC.Lon,80,AF3p,'filled'),colorbar
clim([-2 2])
h = colorbar;
cptcmap('GMT_polar')
ylabel(h,'Amplitude Function 3')
set(h,'fontsize',30)
setm(ax,'mlabelparallel',-90,'plabelmeridian','west','fontsize',30,'mlabellocation',[-120 -60 0 60 120],'plabellocation',[-50 -25 0 25 50])
clear ax h coastlat coastlon c i b1 b2 b3 l
