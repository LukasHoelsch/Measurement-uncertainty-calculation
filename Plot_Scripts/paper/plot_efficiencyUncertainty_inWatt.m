%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot_efficiencyUncertainty_inWatt.m %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualization of the efficency uncertainty for a multiple measurement operation in Watt.
%
%% Acknowledgement: This script and the is based on an earlier version by Philipp Rehlaender and Anian Brosch
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% k = 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot_enable = 1;
save_plot=1;


if plot_enable == 1
    
    %% Figure configuration
    fig.PaperFont = 'Times New Roman'; % Font for fig.
    fig.PaperFontSize = 10; % Font size for fig.
    fig.folder = [project_dir_Figures,'\','T_n_200Nm','/'];
    fig.res = '-r900'; % Graphic resolution (if bitmaps available)
    fig.fh = []; % Initialization of the figure handles
    fig.lg =[];
    fig.sp = []; % Initialization of the subplot handles
    FigW = 8.5; % Relative specification of the page width to be utilized
    FigH = 7; % Relative specification of the page height to be utilized
    
    
    
    fig.fh(end+1) = figure('NumberTitle', 'off', 'name', 'u_eta_MM_watt', 'Resize', 'off', 'RendererMode', 'manual');
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
    [~,h] = contourf(plot_n,plot_T_calc,plot_Up_eta_watt_SM);
    u = colorbar;
    clim([1 130]);
    u.FontSize = 10;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 10;
    u.Label.String = '$U_\mathrm{{p}}$ in W';
  
    h.LevelListMode = 'auto';
    h.LevelStep = .1;
    h.ShowText = 'on';
    h.LineStyle = 'none';
    
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% plot 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig.sp(end+1) = subplot(2,1,2);
    set(fig.sp(end), 'TickLabelInterpreter', 'Latex');
    [~,h] = contourf(plot_n,plot_T_calc,plot_Up_eta_watt_MM);
    u = colorbar;
    clim([1 10]);
    u.FontSize = 10;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 10;
    u.Label.String = '$U_\mathrm{{p}}$ in W';
   
    h.LevelListMode = 'auto';
    h.LevelStep = .1;
    h.ShowText = 'on';
    h.LineStyle = 'none';

    %
    AdjustSubplot(fig,0.05,[0.14 0.15 0.76 0.95],[2 2]);
    %
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% min and max values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x_min = n_min;
    x_max = n_max;
    y_min = motor_selected.T_calc_min;
    y_max = T_max;

    XTicks=[0 2000 4000 6000 8000 10000];
    XTickLabel={'0','2000','4000','6000','8000','10000'};
    
    YTicks = [20,60,100,140,180];
    YTickLabel={'20','60','100','140','180'};

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kk = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=1;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    set(fig.sp(kk), 'XTick', XTicks);
    set(fig.sp(kk), 'YTick', YTicks);
    ylabel('$T$ in $\mathrm{N}{\cdot}\mathrm{m}$','interpreter', 'latex','Fontsize',10);
    set(gca,'TickLabelInterpreter','latex');
    text(10500,150,'SM','interpreter','latex','Fontsize',10,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = 10;
    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% kk = 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=2;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    set(fig.sp(kk), 'XTick', XTicks);
    set(fig.sp(kk), 'YTick', YTicks);
    xlabel('$n$ in 1/min','interpreter', 'latex','Fontsize',10);
    ylabel('$T$ in $\mathrm{N}{\cdot}\mathrm{m}$','interpreter', 'latex','Fontsize',10);
    set(gca,'TickLabelInterpreter','latex');
    text(10500,150,'MM','interpreter','latex','Fontsize',10,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = 10;
    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     if save_plot ==1
            FigName = ['u_eta_InWatt.pdf'];
        if exist([fig.folder FigName]) == 0
                %% select between pdf and svg file
                print('-dpdf','-painters', fig.res,[fig.folder FigName]);
                %print('-dsvg','-painters', fig.res,[fig.folder FigName]);
            else
                choice = questdlg(['Datei "' FigName '" existiert bereit! Überschreiben?'], 'Problem', 'Ja', 'Nein', 'Ja');
            if strcmp(choice, 'Ja')
                %% select between pdf and svg file
                print(fig.fh(end), '-dpdf', '-painters' , fig.res,[fig.folder FigName]);
                 %print(fig.fh(end), '-dsvg', '-painters' , fig.res,[fig.folder FigName]);
            end
       end
     end 

end