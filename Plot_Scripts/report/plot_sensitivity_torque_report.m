%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot_sensitivity_torque_report.m %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualization of the sensetitiy coefficient for the torque measurement.
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
save_plot=1;


if plot_enable == 1
    
    %% Figure Configuration
    fig.PaperFont = 'Times New Roman';  % Schriftart für Abb.
    fig.PaperFontSize = 10;     % Schriftgröße für Abb.
    fig.folder = [project_dir_Figures,'\report\'];
    fig.res = '-r900';  % Grafikauflösung (falls bitmaps vorhanden)
    fig.fh = [];    % Intialisierung der figure handles
    fig.lg =[];
    fig.sp = [];    % Initialisierung der subplot handles
    FigW = 12;     % Relative Angabe der zu verwendenten Seitenbreite, hier kompl. Breite
    FigH = 8;       % Relative Angabe der zu verwendenten Seitenhöhe, hier rund 1/4 der höhe
    
    
    
    fig.fh(end+1) = figure('NumberTitle', 'off', 'name', 'sensitivity_torque', 'Resize', 'off', 'RendererMode', 'manual');
    set(fig.fh(end),'PaperPositionMode','manual','PaperUnits','centimeters','Units','centimeters', 'PaperType', 'A4', 'Renderer', 'opengl');
    set(fig.fh(end),'defaulttextinterpreter','latex',...
                'DefaultAxesFontSize',fig.PaperFontSize,...
                'DefaultTextFontSize',fig.PaperFontSize,...
                'DefaultTextFontName',fig.PaperFont,...
                'DefaultAxesFontName',fig.PaperFont,...
                'PaperSize',[FigW FigH],...
                'PaperPosition',[0,0,FigW,FigH],...
                'Position',[1,1,FigW,FigH]);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% plot 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig.sp(end+1) = subplot(2,1,1);
    set(fig.sp(end), 'TickLabelInterpreter', 'Latex');
    [~,h] = contourf(plot_n,plot_T_calc,plot_c_T_SM)
    u = colorbar
    u.FontSize = 14;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 14;
    u.Label.String = '$c_\mathrm{T}$';

    h.LevelListMode = 'manual';
    h.LevelStep = 0.01;
    h.ShowText = 'on';
    h.LineStyle = 'none';
 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% plot 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig.sp(end+1) = subplot(2,1,2);
    set(fig.sp(end), 'TickLabelInterpreter', 'Latex');
    [~,h] = contourf(plot_n,plot_T_calc,plot_c_T_MM)
    u = colorbar;
    u.FontSize = 14;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 14;
    u.Label.String = '$c_\mathrm{T}$';


    h.LevelListMode = 'manual';
    h.LevelStep = 0.01;
    h.ShowText = 'on';
    h.LineStyle = 'none';

    %
    AdjustSubplot(fig,0.05,[0.14 0.16 0.75 0.95],[2 2]);
    %
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% min and max values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x_min = n_min;
    x_max = n_max;
    y_min = motor_selected.T_calc_min;
    y_max = T_max;

   

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kk = 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=1;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    ylabel('$T$ in Nm','interpreter', 'latex','Fontsize',14);
    set(gca,'TickLabelInterpreter','latex');
    text(x_max-x_max/8,y_max-y_max/4,'SM','interpreter','latex','Fontsize',14,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = 14;
    ax.XLabel.FontSize = 14;
    ax.YLabel.FontSize = 14;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kk = 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=2;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    ylabel('$T$ in Nm','interpreter', 'latex','Fontsize',14);
    xlabel('$n$ in 1/min','interpreter', 'latex','Fontsize',14);
    xticks([0+n_max/5 n_max/2 n_max*8/10]);
    set(gca,'TickLabelInterpreter','latex');
    text(x_max-x_max/8,y_max-y_max/4,'MM','interpreter','latex','Fontsize',14,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = 14;
    ax.XLabel.FontSize = 14;
    ax.YLabel.FontSize = 14;

       
     if save_plot ==1
            FigName = ['sensitivity_torque.svg'];
            print('-dsvg','-painters', fig.res,[fig.folder FigName]);
     end 

end

