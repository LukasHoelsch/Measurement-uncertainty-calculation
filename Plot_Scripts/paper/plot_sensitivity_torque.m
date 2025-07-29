%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot_sensitivity_torque.m %%
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
    fig.folder = [project_dir_Figures,'\T_n_200Nm\'];
    fig.res = '-r900';  % Grafikauflösung (falls bitmaps vorhanden)
    fig.fh = [];    % Intialisierung der figure handles
    fig.lg =[];
    fig.sp = [];    % Initialisierung der subplot handles
    FigW = 8.5;     % Relative Angabe der zu verwendenten Seitenbreite, hier kompl. Breite
    FigH = 6;       % Relative Angabe der zu verwendenten Seitenhöhe, hier rund 1/4 der höhe
    
    
    
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
    % clim([0.9166 0.9550]);
    u.FontSize = 10;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 10;
    u.Label.String = '$c_\mathrm{T}$';
    % u.Limits = [0.9,0.99];
    % ZTicks = [0.9,0.94,0.98];
    % ZTickLabel={'0.9','0.94','0.98'};
    % u.Ticks = ZTicks;
    % u.TickLabels = ZTickLabel;


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
    u = colorbar
    % clim([0.9166 0.9550]);
    % u.Limits = [0,0.009];

    u.Ruler.Exponent = 0;  % Keeps tick labels as full numbers
    u.Ruler.TickLabelFormat = '%.0f';  % Adjust format if needed

    pos = u.Position;

    % Place custom text (e.g., "×10^3") manually — adjust x and y as needed
    text(pos(1) + pos(3)/2 +0.47, pos(2) + pos(4) + 0.5, '$\times 10^{-3}$', ...
     'Units', 'normalized', 'HorizontalAlignment', 'center', ...
     'FontSize', 10, 'Interpreter','latex');

    u.FontSize = 10;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 10;
    u.Label.String = '$c_\mathrm{T}$';

    ZTicks = [0.0027,0.00275,0.002800];
    ZTickLabel={'2.7','2.75','2.8'};
    u.Ticks = ZTicks;
    u.TickLabels = ZTickLabel;

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
    x_min = 2000;
    x_max = 11000;
    y_min = 20;
    y_max = 180;

    XTicks=[0 2000 4000 6000 8000 10000];
    XTickLabel={'0','2000','4000','6000','8000','10000'};
    
    YTicks = [20,60,100,140,180];
    YTickLabel={'20','60','100','140','180'};

    % ZTicks = [0.9,0.95,0.99];
    % ZTickLabel={'0.9','0.95','0.99'};

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kk = 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=1;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    set(fig.sp(kk), 'YTick', YTicks);
    %set(fig.sp(kk), 'ZTick', ZTicks);
    ylabel('$T$ in $\mathrm{N}{\cdot}\mathrm{m}$','interpreter', 'latex','Fontsize',10);
    set(fig.sp(kk), 'YTickLabel', YTickLabel,'Fontsize',10);
    set(gca,'TickLabelInterpreter','latex');
    text(10500,150,'SM','interpreter','latex','Fontsize',10,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = 10;
    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;
    %clim([0,max_abs]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% kk = 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=2;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    set(fig.sp(kk), 'YTick', YTicks);
    %set(fig.sp(kk), 'ZTick', ZTicks);
    ylabel('$T$ in $\mathrm{N}{\cdot}\mathrm{m}$','interpreter', 'latex','Fontsize',10);
    xlabel('$n$ in 1/min','interpreter', 'latex','Fontsize',10);
    set(fig.sp(kk), 'YTickLabel', YTickLabel,'Fontsize',10);
    set(gca,'TickLabelInterpreter','latex');
    text(10500,150,'MM','interpreter','latex','Fontsize',10,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = 10;
    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;
    %clim([0,max_abs]);

       
     if save_plot ==1
            FigName = ['sensitivity_torque.pdf'];
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

