% generateReport.m
%%%%%%%%%%%%%%%
% Generate report after evaluation with the utilized parameters.
clc;

import mlreportgen.report.*
import mlreportgen.dom.*
import mlreportgen.utils.*

mlreportgen.dom.FontSize.Value = "11pt"

rpt = Report('Simple','pdf');
rpt.Locale='english';

open(rpt)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Title and subtitle
tp = TitlePage()
tp.Image = which(["\Logo_combi_IAS_blue.svg"]);
tp.Title = "Measurement Uncertainty Evaluation Report";
tp.Subtitle = "Reporting the main results of the measurement uncertainty evaluation with the utilized parameters";
tp.Author = "Lukas Hölsch";
tp.PubDate = date();

append(rpt,tp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Header and Footnote




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% General
% get the current page layout
pageLayout = getReportLayout(rpt);
pageSize = pageLayout.PageSize;
pageMargins = pageLayout.PageMargins;

% Calculate the page body width
bodyWidth = units.toInches(pageSize.Width) - ...
        units.toInches(pageMargins.Left) - ...
        units.toInches(pageMargins.Right);
bodyWidth = sprintf("%0.2fin",bodyWidth);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table of content
toc = TableOfContents();
append(rpt,toc);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Introduction and motivation
append(rpt,Chapter(Title='Introduction and motivation'))

txt_basic1 = Text("Optimizing the efficiency of electric drives is a major " + ...
    "goal in academia and industry. Due to the already high efficiency of electric drives, " + ...
    "the measurement uncertainty has to be very small to measure even small " + ...
    "changes in the efficency, e.g., due to the control method. Therefore, " + ...
    "the uncertainty of already available or in the future planned test benches " + ...
    "must be evaluated. With the presented tool (calculation itself), the users " + ...
    "can evalutate their uncertainties. However, repeating this evaluation with " + ...
    "minor changes of the parameters, the users maybe will lose the specific results. Here, " + ...
    "this tool comes into action. An automatic report with the general simulation " + ...
    "settings, all utilized parameters and results is generated after every evaluation.")
txt_basic1.FontSize = "14";
append(rpt,txt_basic1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basic simulation parameters
append(rpt,Chapter(Title='Basic evaluation parameters'))

txt_basic1 = Text("The basic parameters of the performed evaluation are shown in the table below.")
txt_basic1.FontSize = "14";
append(rpt,txt_basic1);

basic_parameters = ["T_min","T_max","n_min","n_max","i_max","v_DC","k_p"]';
basic_values = [motor_selected.T_calc_min,T_max, n_min,n_max,i_max,v_DC,k_p]';
basic_units = ["Nm","Nm","1/min","1/min","A","V",""]';

table_basic = FormalTable(["Parameter","Value","Unit"],[basic_parameters,basic_values,basic_units])
table_basic.HAlign='center';
table_basic.TableEntriesStyle = {FontSize('11')};
tableRptr_basic = BaseTable(table_basic)
tableRptr_basic.Title = "Basic evaluation parameters";
append(rpt,tableRptr_basic)


%%  utilized measurement equipment
txt = "";
append(rpt,txt);

% Torque transducer
txt = "The utilized torque transducer is:";
append(rpt,txt);
para = Paragraph();
paraTitle = Text(sprintf("%c", torqueFlange_selected.name));
paraTitle.Bold = true;
append(para,paraTitle);
append(rpt,para);


% Current transducer
txt_currentTransducer1 = "The utilized current transducer is: ";
append(rpt,txt_currentTransducer1);
para_currentTransducer = Paragraph();
paraTitle = Text(sprintf("%c", powerAnalyzer_selected.nameCT));
paraTitle.Bold = true;
append(para_currentTransducer,paraTitle)
append(rpt,para_currentTransducer);


% Power analyzer
txt_powerAnaylzer = "The utilized power analyzer is: ";
append(rpt,txt_powerAnaylzer);
para_powerAnalyzer = Paragraph();
paraTitle = Text(sprintf("%c", powerAnalyzer_selected.name));
paraTitle.Bold = true;
append(para_powerAnalyzer,paraTitle)
append(rpt,para_powerAnalyzer);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table with the utilized parameters
% Add chapter
append(rpt,Chapter(Title='Utilized Parameters'));

txt = "The utilized parameters for the uncertainty evaluation are taken form the data sheets. First, the parameters of the torque measurement system is given in the table below.";
append(rpt,txt);

% create vertical linespace
txt = "";
append(rpt,txt);

txt = "The utilized torque transducer is:";
append(rpt,txt);
para = Paragraph();
paraTitle = Text(sprintf("%c", torqueFlange_selected.name));
paraTitle.Bold = true;
append(para,paraTitle);
append(rpt,para);

%% torque
txt_sigma = sprintf("\x3C3_rel");

parameter_torque = ["T_n","d_c","d_lh",txt_sigma,"n_max"]';
parameter_value_torque = [torqueFlange_selected.T_n,...
    torqueFlange_selected.d_c,torqueFlange_selected.d_lh,...
    torqueFlange_selected.sigma_rel,n_max]';
units_torque = ["Nm","","","","1/min"]';

table_torque = FormalTable(["Parameter","Value","Unit"],["Torque","",""],[parameter_torque,parameter_value_torque,units_torque]);
table_torque.HAlign='center';
tableRptr_torque = BaseTable(table_torque);
tableRptr_torque.Title = "Parameters torque measurement";
append(rpt,tableRptr_torque);

% create vertical linespace
txt = "";
append(rpt,txt);
% create vertical linespace
txt = "";
append(rpt,txt);

%% current transducer
txt_currentTransducer1 = "The utilized current transducer is: ";
append(rpt,txt_currentTransducer1);
para_currentTransducer = Paragraph();
paraTitle = Text(sprintf("%c", powerAnalyzer_selected.nameCT));
paraTitle.Bold = true;
append(para_currentTransducer,paraTitle)
append(rpt,para_currentTransducer);

parameter_currentTransducer = ["d_CT_lin","d_CT_offset","d_CT_f","d_CT_phi_fix","I_CT_MR"]';
parameter_value_currentTransducer = [powerAnalyzer_selected.d_CT_lin,...
    powerAnalyzer_selected.d_CT_offset,...
    powerAnalyzer_selected.d_CT_f,...
    powerAnalyzer_selected.d_CT_phi_fix,...
    powerAnalyzer_selected.I_CT_MR]';
units_currentTransducer = ["","","","",""]';

table_currentTransducer = FormalTable(["Parameter","Value","Unit"],[parameter_currentTransducer,parameter_value_currentTransducer,units_currentTransducer]);
table_currentTransducer.HAlign='center';
tableRptr_currentTransducer = BaseTable(table_currentTransducer);
tableRptr_currentTransducer.Title = "Parameters current tranducer";
append(rpt,tableRptr_currentTransducer);

% create vertical linespace
txt = "";
append(rpt,txt);
% create vertical linespace
txt = "";
append(rpt,txt);

txt_powerAnaylzer = "The utilized power analyzer is: ";
append(rpt,txt_powerAnaylzer);
para_powerAnalyzer = Paragraph();
paraTitle = Text(sprintf("%c", powerAnalyzer_selected.name));
paraTitle.Bold = true;
append(para_powerAnalyzer,paraTitle)
append(rpt,para_powerAnalyzer);

% power analyzer
parameter_powerAnalyzer = ["d_i_DC","d_v_DC","d_i_fund","d_i_harm","d_v_fund","d_v_harm","d_i_DC_MR","d_v_DC_MR","d_i_fund_MR","d_i_harm_MR","d_v_fund_MR","d_v_harm_MR","d_pulse1","d_pulse2"]';

parameter_value_powerAnalyzer =[
    powerAnalyzer_selected.d_current_DC,...
    powerAnalyzer_selected.d_voltage_DC,...
    powerAnalyzer_selected.d_current_fund,...
    powerAnalyzer_selected.d_current_harm,...
    powerAnalyzer_selected.d_voltage_fund,...
    powerAnalyzer_selected.d_voltage_harm,...
    powerAnalyzer_selected.d_current_DC_MR,...
    powerAnalyzer_selected.d_voltage_DC_MR,...
    powerAnalyzer_selected.d_current_fund_MR,...
    powerAnalyzer_selected.d_current_harm_MR,...
    powerAnalyzer_selected.d_voltage_fund_MR,...
    powerAnalyzer_selected.d_voltage_harm_MR,...
    powerAnalyzer_selected.d_pulse_1,...
    powerAnalyzer_selected.d_pulse_2
]';

units_powerAnalyzer = strings(1,14)';


% create formal table
table_powerAnalyzer = FormalTable(["Parameter","Value","Unit"],[parameter_powerAnalyzer,parameter_value_powerAnalyzer,units_powerAnalyzer]);
table_powerAnalyzer.HAlign='center';

% cerate a base table with the formal table as content
% with this procedure a label can be added to the formal table
tableRptr_table_powerAnalyzer = BaseTable(table_powerAnalyzer);
tableRptr_table_powerAnalyzer.Title = "Parameters power analyzer";


%% Hier geht es weiter
% Tabellenbeschriftung formatieren

% Create a 1-by-1 invisible layout table (lo_table). A table is considered
% invisible when the borders are not defined for the table and its table entries
lo_pa_table = Table(1);
row = append(lo_pa_table,TableRow);
entry = append(row,TableEntry);

% Add the paragraphs that contain the image and caption content to the only
% table entry in the invisible layout table
append(entry,tableRptr_table_powerAnalyzer.Title);

append(rpt,tableRptr_table_powerAnalyzer);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Results  
append(rpt,Chapter(Title='Results'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Electric drive
result_efficiency = Text("The electric drive's efficiency is shown in Fig. 1.");
add(rpt,result_efficiency);

figure_dir_report = [project_dir_Figures,'\report','\efficiency_drive.svg'];

% create a formal image
formalImage = FormalImage(figure_dir_report);
formalImage.Caption = "Electric drive's efficiency.";

% Use the getImageReporter method of the FormalImage reporter to get the image
% reporter and the getCaptionReporter method to get the caption reporte
imageReporter = getImageReporter(formalImage,rpt);
captionReporter = getCaptionReporter(formalImage);

% Use the getImpl methods of the image and caption reporters to get the
% corresponding DOM implementations
imageImpl = getImpl(imageReporter,rpt);
captionImpl = getImpl(captionReporter,rpt);

% The DOM implementations contain a DOM Paragraph that contains the image and caption content.
% Update the style of the paragraphs to make sure that there is no white space around the paragraphs
% and that they are centered in the table entry that is created in a subsequent step
paraStyle = { ...
        OuterMargin("0in","0in","0in","0in"), ...
        HAlign("center") ...
        };
    
imagePara = clone(imageImpl.Children(1));
imagePara.Style = [imagePara.Style, paraStyle];

captionPara = clone(captionImpl.Children(1));
captionPara.Style = [captionPara.Style, paraStyle];

% Create a 1-by-1 invisible layout table (lo_table). A table is considered
% invisible when the borders are not defined for the table and its table entries
lo_table = Table(1);
row = append(lo_table,TableRow);
entry = append(row,TableEntry);

% Add the paragraphs that contain the image and caption content to the only
% table entry in the invisible layout table
append(entry,imagePara);
append(entry,captionPara);

% Span the table to the available page body width
lo_table.Width = bodyWidth;

% Center the table
lo_table.TableEntriesStyle = [lo_table.TableEntriesStyle ...
        { ...
        HAlign("center"), ...
        VAlign("middle") ...
        }];

% Add the layout table to the report
add(rpt,lo_table)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Efficiency Uncertainty
txt_result = Text("The uncertainty for an efficiency evaluation of the electric drive is visualized in Fig. 2.");
add(rpt,txt_result);

figure_dir_report = [project_dir_Figures,'\report','\efficiencyUncertainty.svg'];

% create a formal image
formalImage = FormalImage(figure_dir_report);
formalImage.Caption = "Uncertainty for an efficiency evaluation.";

% Use the getImageReporter method of the FormalImage reporter to get the image
% reporter and the getCaptionReporter method to get the caption reporte
imageReporter = getImageReporter(formalImage,rpt);
captionReporter = getCaptionReporter(formalImage);

% Use the getImpl methods of the image and caption reporters to get the
% corresponding DOM implementations
imageImpl = getImpl(imageReporter,rpt);
captionImpl = getImpl(captionReporter,rpt);

% The DOM implementations contain a DOM Paragraph that contains the image and caption content.
% Update the style of the paragraphs to make sure that there is no white space around the paragraphs
% and that they are centered in the table entry that is created in a subsequent step
paraStyle = { ...
        OuterMargin("0in","0in","0in","0in"), ...
        HAlign("center") ...
        };
    
imagePara = clone(imageImpl.Children(1));
imagePara.Style = [imagePara.Style, paraStyle];

captionPara = clone(captionImpl.Children(1));
captionPara.Style = [captionPara.Style, paraStyle];

% Create a 1-by-1 invisible layout table (lo_table). A table is considered
% invisible when the borders are not defined for the table and its table entries
lo_table = Table(1);
row = append(lo_table,TableRow);
entry = append(row,TableEntry);

% Add the paragraphs that contain the image and caption content to the only
% table entry in the invisible layout table
append(entry,imagePara);
append(entry,captionPara);

% Span the table to the available page body width
lo_table.Width = bodyWidth;

% Center the table
lo_table.TableEntriesStyle = [lo_table.TableEntriesStyle ...
        { ...
        HAlign("center"), ...
        VAlign("middle") ...
        }];

% Add the layout table to the report
add(rpt,lo_table)





%% Torque Sensitivity
txt_result = Text("The sensitivity of the torque measurement is shown in Fig. 3.");
add(rpt,txt_result);

figure_dir_report = [project_dir_Figures,'\report','\sensitivity_T.svg'];

% create a formal image
formalImage = FormalImage(figure_dir_report);
formalImage.Caption = "Sensitivity for the torque measurement.";

% Use the getImageReporter method of the FormalImage reporter to get the image
% reporter and the getCaptionReporter method to get the caption reporte
imageReporter = getImageReporter(formalImage,rpt);
captionReporter = getCaptionReporter(formalImage);

% Use the getImpl methods of the image and caption reporters to get the
% corresponding DOM implementations
imageImpl = getImpl(imageReporter,rpt);
captionImpl = getImpl(captionReporter,rpt);

% The DOM implementations contain a DOM Paragraph that contains the image and caption content.
% Update the style of the paragraphs to make sure that there is no white space around the paragraphs
% and that they are centered in the table entry that is created in a subsequent step
paraStyle = { ...
        OuterMargin("0in","0in","0in","0in"), ...
        HAlign("center") ...
        };
    
imagePara = clone(imageImpl.Children(1));
imagePara.Style = [imagePara.Style, paraStyle];

captionPara = clone(captionImpl.Children(1));
captionPara.Style = [captionPara.Style, paraStyle];

% Create a 1-by-1 invisible layout table (lo_table). A table is considered
% invisible when the borders are not defined for the table and its table entries
lo_table = Table(1);
row = append(lo_table,TableRow);
entry = append(row,TableEntry);

% Add the paragraphs that contain the image and caption content to the only
% table entry in the invisible layout table
append(entry,imagePara);
append(entry,captionPara);

% Span the table to the available page body width
lo_table.Width = bodyWidth;

% Center the table
lo_table.TableEntriesStyle = [lo_table.TableEntriesStyle ...
        { ...
        HAlign("center"), ...
        VAlign("middle") ...
        }];

% Add the layout table to the report
add(rpt,lo_table)




































close(rpt)