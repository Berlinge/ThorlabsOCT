function [Int ]=speckle_generator(lambda,NA,n,Sim_Objective)
% clear all
% close all
%  Laser Speckle generated thorugh an objective by Marco Leonetti. 06/18/2021
%  Algorithm based on the summation of plane waves with K vectors extracted randomply with
%  directions compatible with an objective lens (with Numerical aperture NA)
%  illuimination.
%  The model is for one or two polarization (Polarizations Variable)
%  The software also support the simulation of the focused spot size (focusing Point Spread Function ) of an
%  objective. (Put Sim_Objective to 1)
%  in this case the plane wave dephasing is set to zero (flat wavefront t
%  the objective input).
%  Note that this simulation does not take into account K-dependence of the
%  coupling efficiency of the plane waves to the objectiwes which may
%  slightly modify the objective 
%  See also  https://mlphotonics.wordpress.com/
% n=1.0;                          % refractive index of the media in which light is propagating
% NA=0.75;                        % Numerical aperture of the optical system
% lambda=0.532;                   % wavelenght nin microns
% Sim_Objective=logical(0);       % 0 or 1; Put 0 to simulate a speckle pattern. Put to 1 to simulate the objective focus instead of a speckle summation.
Lenght=6                        % Lenght of the square area of interest
numpoints=361;                  % Number of points defining the sampling rate in the sample plane, for Sim_Objective_
N_PWav=1000;                    % number of plane waves to be summed. 
Polarizations=1                 % Active polarizations. If Polarizations==1 it is like placing a polarizer in front of the region of interests.
Visualization=logical(1);       % put 1 to visualize the Region of interest intensity and field.
%%
Sim_Objective=logical(Sim_Objective);
Resolution=Lenght/numpoints;                % Spatial resolution of the numerical experiment (microns)
K=2*pi*n/lambda                             % K vector modulus for the plane waves
Max_Pol=asin(NA/n);                         % maximum of the polar angle
% generating meshgrid
XXX_V=linspace(-Lenght/2,Lenght/2,numpoints);
YYY_V=linspace(-Lenght/2,Lenght/2,numpoints);
[YYY XXX ]=meshgrid(XXX_V,YYY_V);
if Polarizations==1
    N_PWav_eff=N_PWav;
elseif Polarizations==2
    N_PWav_eff=N_PWav*2;
end
%% Plane waves Cycles
for ppp =1:N_PWav_eff;
    
    Pol(ppp)=rand*Max_Pol;                   %% extraction of random polar angle for incoming light
    Az(ppp)=rand*2*pi;                       %% extraction of random azimutal angle for incoming light
    Ampl_V(ppp)=rand;                        %% extraction of random amplitude. If transmitted trhough a disordered medium should be exponentially distributed
    if Sim_Objective
        Phy_V(ppp)=0;                    %% to simulate an objective output put this Sim_Objective==1; 
    else
        Phy_V(ppp)=rand*2*pi;                %% extraction of the plane waves phase delay due to the sourche roughness (fully developed speckles see also Goodmann Book https://spie.org/Publications/Book/2548482?SSO=1)
    end
    
    
    % K_vect_components
    
    K_z=K*cos(Pol(ppp));
    K_xy=K*sin(Pol(ppp));
    K_x=K_xy*cos(Az(ppp));
    K_y=K_xy*sin(Az(ppp));
    
    Ampl=Ampl_V(ppp);
    Phy=Phy_V(ppp);
    
    %field from the ppp plane wave
    Field(:,:,ppp)=Ampl.*exp(   i*( XXX.*K_x +  YYY*K_y  +  Phy )   );
    
    
    
end
%%
if Polarizations==1
% total Field
Tot_Field=sum(Field,3);
% intensity
Int=Tot_Field.*(conj(Tot_Field));
elseif Polarizations==2
    Field_pol_1=Field(:,:,1:N_PWav_eff/2);
    Field_pol_2=Field(:,:,N_PWav_eff/2+1:N_PWav_eff);
    Tot_Field_1=sum(Field_pol_1,3);
    Tot_Field_2=sum(Field_pol_2,3);
    Int_1=Tot_Field_1.*(conj(Tot_Field_1));
    Int_2=Tot_Field_2.*(conj(Tot_Field_2));
    Field=Field_pol_1;
    Int=Int_2+Int_1;
end
%% Visualizing
if Visualization
    % field from a random wave
    figure
    subplot(1,2,1)
    set(gcf,'position',[396   354   926   360])
    RandomPlaneWaveVisualized=randi([1 N_PWav]);
    imagesc(real(Field(:,:, RandomPlaneWaveVisualized)))
    Title_str_1=['Field from plane wave ' num2str(RandomPlaneWaveVisualized) ';  K_{xy}: ' num2str(K*sin(Pol(RandomPlaneWaveVisualized))) ' \mum^{-1} ' ];
    title(Title_str_1)
    axis off
    axis image
    
    % Total intensity
    
    subplot(1,2,2)
    imagesc(Int)
    Title_str_2=['Intensity. NA= ' num2str(NA) '; \lambda=' num2str(lambda) '; n: '  num2str(n) ];
    title(Title_str_2)    
    
    label_str=['Field of view side: ' num2str(Lenght) ' \mum' ];
    t = annotation('textbox');
    t.String = label_str;
    t.Position=[0.4300    0.0381    0.3857    0.0619]
    t.EdgeColor ='none'
    axis off
    axis image
    
        
    
    
end
if Sim_Objective
    
    %%computing PSF profile
    center=[round(numpoints/2) round(numpoints/2)]
    Int_X=Int(center(1),:);
    Int_X_N=Int_X/(max(max(Int_X)));
    XXX_um=1:numel(Int_X);
    XXX_um=XXX_um-center(2)
    XXX_um=XXX_um*Resolution;
    %%limits of the FWHM (LOWER)
    jjj=1;
    while Int_X_N(jjj)<0.5
    jjj=jjj+1;
    end
    jjj1=jjj;
    LL_FW=XXX_um(jjj);
    
    %%limits of the FWHM (UPPER)
    jjj=numel(Int_X_N);
    while Int_X_N(jjj)<0.5
    jjj=jjj-1;
    end
    jjj2=jjj;
    UL_FW=XXX_um(jjj);
    
    
    FWHM=UL_FW-LL_FW
    Theor_FWHM=lambda*0.61/(NA)
    
    
    if Visualization
    figure
    plot(XXX_um,Int_X_N)
    hold on
    plot([XXX_um(jjj1) XXX_um(jjj2)],[Int_X_N(jjj1) Int_X_N(jjj2)],'-.' )
    xlabel('X \mum')
    ylabel('Int. Arb. Units')
    Titlestr_=['P.S.F. Profile; FWHM: ' num2str(FWHM) ]
    title (Titlestr_)
    end
    
end
