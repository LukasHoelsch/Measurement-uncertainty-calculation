%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot_MotorLoss.m %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Visualization of the motor loss from the data sheet.
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


if plot_enable == 1
    
    %% Figure configuration
    fig.PaperFont = 'Times New Roman'; % Font for fig.
    fig.PaperFontSize = 10; % Font size for fig.
    fig.folder = [project_dir_Figures,'\']; % Folder to save the figure
    fig.res = '-r900'; % Graphic resolution (if bitmaps available)
    fig.fh = []; % Initialization of the figure handles
    fig.lg =[];
    fig.sp = []; % Initialization of the subplot handles
    FigW = 8.5; % Relative specification of the page width to be utilized
    FigH = 4.5; % Relative specification of the page height to be utilized
    
    
    
    fig.fh(end+1) = figure('NumberTitle', 'off', 'name', 'MotorLoss', 'Resize', 'off', 'RendererMode', 'manual');
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
    [~,h] = contourf(plot_n,plot_T_calc,plot_motor_P_loss)
    u = colorbar
    u.FontSize = 10;
    u.TickLabelInterpreter = 'latex';
    u.Label.Interpreter = 'latex';
    u.Label.FontSize = 10;
    u.Label.String = '$P_{\mathrm{l}}$ in kW';
    u.Ticks = [200,400,1000,2000,4000,7000];
    u.TickLabels = {'0.2','0.5','1','2','4','7'};

%
    h.LevelListMode = 'auto';
    h.LevelStep = 100;
    h.ShowText = 'on';
    h.LineStyle = 'none';
 

    %
    AdjustSubplot(fig,0.05,[0.14 0.16 0.76 0.95],[2]);
    %
    
    x_min = 2000;
    x_max = 11000;
    y_min = 20;
    y_max = 180;

    XTicks=[0 2000 4000 6000 8000 10000];
    XTickLabel={'0','2000','4000','6000','8000','10000'};
    
    YTicks = [20,60,100,140,180];
    YTickLabel={'20','60','100','140','180'};

    
    kk=1;
    subplot(fig.sp(kk))
    set(fig.sp(kk), 'xlim', [x_min x_max]);
    set(fig.sp(kk), 'ylim', [y_min y_max]);
    set(fig.sp(kk), 'XTick', XTicks);
    set(fig.sp(kk), 'YTick', YTicks);
    %set(fig.sp(kk), 'ZTick', ZTicks);
    xlabel('$n$ in 1/min','interpreter', 'latex','Fontsize',10);
    ylabel('$T$ in Nm','interpreter', 'latex','Fontsize',10);
    set(fig.sp(kk), 'XTickLabel', XTickLabel,'Fontsize',10);
    set(fig.sp(kk), 'YTickLabel', YTickLabel,'Fontsize',10);
    set(gca,'TickLabelInterpreter','latex');
    ax = gca;
    ax.FontSize = 10;
    ax.XLabel.FontSize = 10;
    ax.YLabel.FontSize = 10;
    ax.ColorScale = "log";
    
    

    
     if save_plot ==1
            FigName = ['MotorLoss.pdf'];
            %FigName = ['MotorLoss.eps'];
        if exist([fig.folder FigName]) == 0
                print('-dpdf','-painters', fig.res,[fig.folder FigName]);
                %print('-deps','-painters', fig.res,[fig.folder FigName]);
                
            else
                choice = questdlg(['Datei "' FigName '" existiert bereit! Überschreiben?'], 'Problem', 'Ja', 'Nein', 'Ja');
            if strcmp(choice, 'Ja')
                 print(fig.fh(end), '-dpdf', '-painters' , fig.res,[fig.folder FigName]);
                 %print(fig.fh(end), '-deps', '-painters' , fig.res,[fig.folder FigName]);
                 
            end
       end
     end 

end

