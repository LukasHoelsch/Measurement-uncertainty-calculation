# Evaluation of the Efficiency Measurement Uncertainty of Electric Drive Test Benches for Direct Data-Driven Control Optimization

This GitHub page features the uncertainty-calculation toolchain used in the proposal "Evaluation of the Efficiency Measurement Uncertainty of Electric Drive Test Benches for Direct Data-Driven Control Optimization"



## Motivation
This script is used to determine the measurement uncertainty for an electric drive test bench. Therefore, the toolchain is split into different class files, representing the electrical machine, inverter, torque transducer etc.
These classes are fed with the specifications of the utilized measurement components, which makes it easily flexible to exchange the components.
An efficiency uncertainty evaluation is given at the end.



## Usage
In the main script, the number of sampling points and the maximum values of the motor are set, as it is shown in the figure below.
<img src="./Figures/readme/settings.png" width="350">

````
%% Settings for the calculation
% rotational speed sampling points

````

To reduce the computation time the main calculation is inside a `parfor` loop.



## Output
The efficiency uncertainty is visualized in the figure below. 


## Sensitivity coefficients
Sensitvity coefficients show the component's uncertainty influence on the total uncertainty. This is very helpful to decerase the systems uncertainty by changing the components with the worst uncertainty first. Therefore, the sensitivity coefficients are calculated in the following, starting with the DC link power as
$$
P_{\mathrm{DC}} = V_{\mathrm{DC}} I_{\mathrm{DC}},
$$
applying the partial derivative leads to:
$$
u_{\mathrm{c,el,dcLink}} = \sqrt{V_{\mathrm{DC}}^2 u_{\mathrm{I,DC}}^2 + I_{\mathrm{DC}}^2 u_{\mathrm{v,DC}}^2 } .
$$

The uncertainty of the mechanical output power is given with:
$$
u_{\mathrm{c,P,mech}} = 
$$







## Folder structure
The folder structure is visualized below.
````bash
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
````

## Existing components
````bash
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
````