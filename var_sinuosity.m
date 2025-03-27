% Computation of variable sinuosity from thalweg location of the channel
%--------------------------------------------
% Written by Dr.Priyesh Kunnummal, NCPOR-Goa, India (Email: priyeshkunnummal@gmail.com)
% Last modified 20-Mar-2025, Matlab R2024b
%=======================================
% This code is part of the paper "Geomorphology of upper Indus Fan and its channel-levee system: Unveiling the submarine fan complexity with high-resolution multibeam bathymetric data" Submitted to JGR-Earth Surface
% Priyesh Kunnummal, C.M. Bijesh, S. Vadakkepuliyambatta, J. John Savio, P. John Kurian (2025)
% Please cite this paper if you find the code useful for your work.!
%=======================================
clear all;

% INPUT from USER
%----------------------------
f_inp_talwg_loca = 'Active_channel_talweg_in_meter_utm43N_50m_samp.txt' ; % Thalweg location, (Easting and Northing) in meter; Provide file name(Data should be sampled at equal interval.!!)
samp_int = 50; % Specify sampling interval of thalweg locations in meter.
c_dist = 12000; % Fixed channel thalweg length in meter; should be multiples of Samp_int.

% specify the average channel-belt width if you want to move mean sinuosity based on
% fixed channel-belt width. 

av_len = 22000 ; % Average channel-belt width in meter (for averaged sinuosity)

%=======================================
% Program starts here
%=======================================
tlwg_d = importdata(f_inp_talwg_loca); % Load thalweg locations
ns = c_dist./samp_int + 1 ; % Number of samples b/w c_dist, +1 added - since distance start with zero.
av_n = av_len./samp_int ; % Number of samples for averaging

st_n = 1; % start loc - changes
en_n = ns ; % end loc -changes
en_ln = length(tlwg_d) - ns ; % end of loop

for i = 1:en_ln    
st_pnt = tlwg_d(st_n,:);
en_pnt = tlwg_d(en_n,:);
seg_dist = norm(en_pnt - st_pnt); % Straight line distance
% compute sinuosity
seg_sin (i) = c_dist / seg_dist ;
cent_dist(i) =  en_n*samp_int - (c_dist./2) ; % find mid-way distance to assign SI value
cent_lon_lat_idx (i) = en_n - ceil(ns./2) ; % find mid-way locations SI value
st_n = 1 + i ;
en_n = ns + i ;
end
cent_lon_lat = tlwg_d(cent_lon_lat_idx,:) ;

% Plot variable sinuosity
figure(1)
plot(cent_dist./1000, seg_sin); 
title('Variable sinuosity');

% Do bin averaging
avu_si = movmean(seg_sin,av_n); 
avu_dist = movmean(cent_dist./1000,av_n); % Averaged Sinuosity 

figure(2)
plot(avu_dist, avu_si);
title('Avg. variable sinuosity');

over_all_SI = (length(tlwg_d)*samp_int) ./ norm(tlwg_d(end,:) - tlwg_d(1,:)); % Compute sinuosity from total length of the channel

% OUTPUT
%--------------
% Writeout the Easting, Northing, Distance and Variable Sinuosity along the Thalweg locations
%=================================================
output_fname = ['Var_Sinuousity_', num2str(c_dist),'.txt'];
writematrix([cent_lon_lat,cent_dist'./1000,seg_sin'],output_fname,'Delimiter','tab');

out_avg_SI_fname = ['Avg_Var_Sinuousity_', num2str(c_dist),'_avg_',num2str(av_len),'.txt'];
writematrix([avu_dist',avu_si'],out_avg_SI_fname,'Delimiter','tab');
%--------------------------------
disp([' The over all sinuosity equals to  ', num2str(over_all_SI)]);

%---- End of script ----- best wishes..!!


