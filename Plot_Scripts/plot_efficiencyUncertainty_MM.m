%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot_Up_eta_MM.m %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualization of the efficency uncertainty for a multiple measurement operation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off;

currentFolder = pwd;

colormatrix=[0.000 0.447 0.741;
             0.850 0.325 0.098;
             0.929 0.694 0.125;
             0.494 0.184 0.556;
             0.466 0.674 0.188;
             0.301 0.745 0.933;
             0.635 0.078 0.184];

blue=colormatrix(1,:);
red=colormatrix(2,:);
yellow=colormatrix(3,:);
purple=colormatrix(4,:);
green=colormatrix(5,:);
lblue=colormatrix(6,:);
dred=colormatrix(7,:);


%%
plot_enable = 1;
save_plot=0;


if plot_enable == 1
    
    %% Figure Configuration
    fig.PaperFont = 'Times New Roman'; %Schriftart für Abb.
    fig.PaperFontSize = 10; %Schriftgröße für Abb.
    fig.folder = [project_dir_Figures,'\'];
    fig.res = '-r900'; %Grafikauflösung (falls bitmaps vorhanden)
    fig.fh = []; %Intialisierung der figure handles
    fig.lg =[];
    fig.sp = []; %Initialisierung der subplot handles
    FigW = 8.5; %Relative Angabe der zu verwendenten Seitenbreite, hier kompl. Breite
    FigH = 4.5; %Relative Angabe der zu verwendenten Seitenhöhe, hier rund 1/4 der höhe
    
    
    
    fig.fh(end+1) = figure('NumberTitle', 'off', 'name', 'u_MM', 'Resize', 'off', 'RendererMode', 'manual');
    set(fig.fh(end),'PaperPositionMode','manual','PaperUnits','centimeters','Units','centimeters', 'PaperType', 'A4', 'Renderer', 'opengl');
    set(fig.fh(end),'defaulttextinterpreter','latex',...
                'DefaultAxesFontSize',fig.PaperFontSize,...
                'DefaultTextFontSize',fig.PaperFontSize,...
                'DefaultTextFontName',fig.PaperFont,...
                'DefaultAxesFontName',fig.PaperFont,...
                'PaperSize',[FigW FigH],...
                'PaperPosition',[0,0,FigW,FigH],...
                'Position',[1,1,FigW,FigH]);
    
    fig.sp(end+1) = subplot(1,1,1);
    set(fig.sp(end), 'TickLabelInterpreter', 'Latex');
    [~,h] = contourf(plot_n,plot_T_calc,plot_Up_eta_MM);
    u = colorbar;
    clim([0 0.3]);
    u.FontSize = 10;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 10;
    u.Label.String = '$\mathrm{U_{p}}$ in \%';
    % u.Limits = [0.25, 0.6];
    % u.LimitsMode = "auto";
%
    h.LevelListMode = 'auto';
    h.LevelStep = .1;
    h.ShowText = 'on';
    h.LineStyle = 'none';
    %h.LevelList = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8];
 

    %
    AdjustSubplot(fig,0.05,[0.14 0.16 0.76 0.95],[2]);
    %
    
    x_min = 2000;
    x_max = 11000;
    y_min = 20;
    y_max = 180;
    % z_min = 0;
    % z_max = 0.6;

    XTicks=[0 2000 4000 6000 8000 10000];
    XTickLabel={'0','2000','4000','6000','8000','10000'};
    
    YTicks = [20,60,100,140,180];
    YTickLabel={'20','60','100','140','180'};

%     ZTicks = [0,2000,4000,6000,8000];
%     ZTickLabel={'0','2000','4000','6000','8000'};
    
    % ZTicks = [0,0.05,0.1,0.15,0.2,0.25];
    % ZTickLabel={'0','0.05','0.1','0.15','0.2','0.25'};
    
    kk=1;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    % set(fig.sp(kk), 'zlim', [z_min z_max]);
    set(fig.sp(kk), 'XTick', XTicks);
    set(fig.sp(kk), 'YTick', YTicks);
    % set(fig.sp(kk), 'ZTick', ZTicks);
    xlabel('$n$ in 1/min','interpreter', 'latex','Fontsize',10);
    ylabel('$T$ in Nm','interpreter', 'latex','Fontsize',10);
    set(fig.sp(kk), 'XTickLabel', XTickLabel,'Fontsize',10);
    set(fig.sp(kk), 'YTickLabel', YTickLabel,'Fontsize',10);
    % set(fig.sp(kk), 'ZTickLabel', ZTickLabel,'Fontsize',10);
    set(gca,'TickLabelInterpreter','latex');
    ax = gca;
    ax.FontSize = 10;
    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;

    

    
     if save_plot ==1
            FigName = ['u_MM.pdf'];
        if exist([fig.folder FigName]) == 0
                print('-dpdf','-painters', fig.res,[fig.folder FigName]);
            else
                choice = questdlg(['Datei "' FigName '" existiert bereit! Überschreiben?'], 'Problem', 'Ja', 'Nein', 'Ja');
            if strcmp(choice, 'Ja')
                 print(fig.fh(end), '-dpdf', '-painters' , fig.res,[fig.folder FigName]);
            end
       end
     end 

end