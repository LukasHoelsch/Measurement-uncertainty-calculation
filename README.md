# Analysis of the Measuring Chain at the Test Bench for an Efficiency Evaluation of Electric Drives

This GitHub page features the uncertainty-calculation toolchain used in the proposal "Analysis of the Measuring Chain at the Test Bench for an Efficiency Evaluation of Electric Drives"

This toolchain is used to calculate the uncertainty of an electric drive, which includes the electrical machine, the inverter and the control algorithm. 

#
fitLossBrusa, efficiency in \%, as in the data sheet given. 

# Setup Software


# Software Structure

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
│   │   ├── Ultrastab 867-700I
│   │
│   └── measuringAmplifier
│       ├── ML60B


# Folder Structure

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
│   
├── Spec_Files
│   ├── HSM_16_17_12_C01_spec
│   ├── ML60B_spec
│   ├── SkiiP_1242GB120_4D_spec
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

````bash