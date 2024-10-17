# Analysis of the Measuring Chain at the Test Bench for an Efficiency Evaluation of Electric Drives

This GitHub page features the uncertainty-calculation toolchain used in the proposal "Analysis of the Measuring Chain at the Test Bench for an Efficiency Evaluation of Electric Drives"



## Motivation
This toolchain is used to calculate the uncertainty of an electric drive, which includes the electrical machine, the inverter and the control algorithm, to perform an efficency evaluation of the elctric drive. The calculation of the uncertainty is split into class files for the main componentes, e.g., motorModel, inverterModel and powerAnalyzer. These class files are fed with the specification of the utilized component, as the Yokogawa WT5000. The backgroud here is to easily exchange the components to analyze their influence on the uncertainty within the measuring chain, helping to select the right componets which fits the application's background. 


## Start

<!-- ![alt text](/Figures/readme/settings.png) -->

In the main script, the number of sampling points and the maximum values of the motor are set.

<img src="./Figures/readme/settings.png" width="350">


## Measurement components
The structure of the calculation is shown below, with the main file testBech_evaluation.

````bash
.
├── testBench_evaluation
│   └── init.m
│   │
│   └── motorModel
│       ├── Brusa
│   │
│   └── torqueFlange
│   │   ├── T12HP
│   │   ├── T10FS
│   │    
│   └── powerAnalyzer
│   │   ├── WT3000
│   │   ├── WT5000
│   │    
│   └── currentTransducer
│   │   ├── PM-867-400I
│   │
│   └── measuringAmplifier
│       ├── ML60B


# Folder Structure
The folder strcture is as follows:

.
├── Class_Files
│   ├── inverterModel
│   ├── motorModel
│   ├── powerAnalyzerUncertainty
│   ├── rotationalSpeedAmplifierUncertainty
│   ├── rotationalSpeedUncertainty
│   ├── torqueAmplifierUncertainty
│   ├── torqueUncertainty
│
├── FittedModels
│   ├── fit_lossBrusa.mat
│   ├── fit_Psi_d.mat
│   ├── fit_Psi_q.mat
│   ├── fit_lossBrusa.mat
│   ├── fit_E_on.mat
│   ├── fit_E_off.mat
│   
├── Spec_Files
│   ├── HSM_16_17_12_C01_spec
│   ├── ML60B_spec
│   ├── SkiiP_1242GB120_4D_spec
│   ├── FS02MR12A8MA2B_spec
│   ├── T10FS_spec
│   ├── T12HP_spec
│   ├── WT3000_spec
│   ├── WT5000_spec
│
├── Plot_Files
│   ├── plot_InverterLoss
│   ├── plot_MotorLoss
│   ├── ...
│
└── init
└── testBench_evaluation

