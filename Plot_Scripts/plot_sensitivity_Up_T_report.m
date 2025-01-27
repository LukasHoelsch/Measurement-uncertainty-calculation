%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot_sensitivity_Up_T.m %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualization and comparison between the single and multiple measurement uncertainty for the torque transducer.
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


%%
plot_enable = 1;
save_plot=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% settings
font_size = 14;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if plot_enable == 1
    
    %% Figure configuration
    fig.PaperFont = 'Times New Roman';  % Font for fig.
    fig.PaperFontSize = font_size;     % Font size for fig.
    fig.folder = [project_dir_Figures,'\report','\'];
    fig.res = '-r900';  % Graphic resolution (if bitmaps available)
    fig.fh = [];    % Initialization of the figure handles
    fig.lg =[];
    fig.sp = [];    % Initialization of the subplot handles
    FigW = 12;     % Relative specification of the page width to be utilized
    FigH = 7;       % Relative specification of the page height to be utilized
    
    
    
    fig.fh(end+1) = figure('NumberTitle', 'off', 'name', 'sensitivity_T', 'Resize', 'off', 'RendererMode', 'manual');
    set(fig.fh(end),'PaperPositionMode','manual','PaperUnits','centimeters','Units','centimeters', 'PaperType', 'A4', 'Renderer', 'opengl');
    set(fig.fh(end),'defaulttextinterpreter','latex',...
                'DefaultAxesFontSize',fig.PaperFontSize,...
                'DefaultTextFontSize',fig.PaperFontSize,...
                'DefaultTextFontName',fig.PaperFont,...
                'DefaultAxesFontName',fig.PaperFont,...
                'PaperSize',[FigW FigH],...
                'PaperPosition',[0,0,FigW,FigH],...
                'Position',[1,1,FigW,FigH]);
    
    max_abs = max(max(plot_Up_eta_MM));
    max_rel = max(max(plot_Up_eta_MM));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% plot 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig.sp(end+1) = subplot(2,1,1);
    set(fig.sp(end), 'TickLabelInterpreter', 'Latex');
    [~,h] = contourf(plot_n,plot_T_calc,plot_Up_T_SM)
    u = colorbar
    clim([0.05 .15]);
    u.FontSize = font_size;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = font_size;
    u.Label.String = '$U_\mathrm{{p}}$ in Nm';


    h.LevelListMode = 'manual';
    h.LevelStep = 0.001;
    h.ShowText = 'off';
    h.LineStyle = 'none';
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% plot 2
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fig.sp(end+1) = subplot(2,1,2);
    set(fig.sp(end), 'TickLabelInterpreter', 'Latex');
    [~,h] = contourf(plot_n,plot_T_calc,plot_Up_T_MM)
    u = colorbar
    clim([0.05 .15]);
    u.FontSize = font_size;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = font_size;
    u.Label.String = '$U_\mathrm{{p}}$ in Nm';
%
    h.LevelListMode = 'manual';
    h.LevelStep = 0.001;
    h.ShowText = 'off';
    h.LineStyle = 'none';
    
    

    %
    AdjustSubplot(fig,0.05,[0.14 0.25 0.76 0.95],[2 2]);
    %
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% min and max values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x_min = n_min;
    x_max = n_max;
    y_min = motor_selected.T_calc_min;
    y_max = T_max;

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% k = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=1;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    ylabel('$T$ in Nm','interpreter', 'latex','Fontsize',font_size);
    set(gca,'TickLabelInterpreter','latex');
    text(x_max-x_max/8,y_max-y_max/4,'SM','interpreter','latex','Fontsize',font_size,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = font_size;
    ax.XLabel.FontSize = font_size;
    ax.YLabel.FontSize = font_size;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% k = 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kk=2;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    xlabel('$n$ in 1/min','interpreter', 'latex','Fontsize',font_size);
    ylabel('$T$ in Nm','interpreter', 'latex','Fontsize',font_size);
    set(gca,'TickLabelInterpreter','latex');
    text(x_max-x_max/8,y_max-y_max/4,'MM','interpreter','latex','Fontsize',font_size,'BackgroundColor','#D3D3D3','Margin',1,'HorizontalAlignment','right');
    ax = gca;
    ax.FontSize = font_size;
    ax.XLabel.FontSize = font_size;
    ax.YLabel.FontSize = font_size;

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% save plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
     if save_plot ==1
        FigName = ['sensitivity_T.svg'];
        print('-dsvg','-painters', fig.res,[fig.folder FigName]);
    end 

end

